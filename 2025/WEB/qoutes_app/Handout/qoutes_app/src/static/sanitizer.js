
const uriAttrs = [
    'background',
    'cite',
    'href',
    'itemtype',
    'longdesc',
    'poster',
    'src',
    'xlink:href'
  ]
  
  const ARIA_ATTRIBUTE_PATTERN = /^aria-[\w-]*$/i
  
  const DefaultWhitelist = {
    '*': ['class', 'dir', 'id', 'lang', 'role', ARIA_ATTRIBUTE_PATTERN],
    a: ['target', 'href', 'title', 'rel'],
    area: [],
    b: [],
    br: [],
    col: [],
    code: [],
    div: [],
    em: [],
    hr: [],
    h1: [],
    h2: [],
    h3: [],
    h4: [],
    h5: [],
    h6: [],
    i: [],
    img: ['src', 'alt', 'title', 'width', 'height'],
    li: [],
    ol: [],
    p: [],
    input:[],
    pre: [],
    s: [],
    small: [],
    span: [],
    sub: [],
    sup: [],
    strong: [],
    u: [],
    ul: [],
    form: [],
  }
  
  const SAFE_URL_PATTERN = /^(?:(?:https?|mailto|ftp|tel|file):|[^&:/?#]*(?:[/?#]|$))/gi
  
  
  const DATA_URL_PATTERN = /^data:(?:image\/(?:bmp|gif|jpeg|jpg|png|tiff|webp)|video\/(?:mpeg|mp4|ogg|webm)|audio\/(?:mp3|oga|ogg|opus));base64,[a-z0-9+/]+=*$/i
  
  function allowedAttribute(attr, allowedAttributeList) {
    const attrName = attr.nodeName.toLowerCase()
  
    if (allowedAttributeList.indexOf(attrName) !== -1) {
      if (uriAttrs.indexOf(attrName) !== -1) {
        return Boolean(attr.nodeValue.match(SAFE_URL_PATTERN) || attr.nodeValue.match(DATA_URL_PATTERN))
      }
  
      return true
    }
  
    const regExp = allowedAttributeList.filter((attrRegex) => attrRegex instanceof RegExp)
  

    

    for (let i = 0, l = regExp.length; i < l; i++) {
      if (attrName.match(regExp[i])) {
        return true
      }
    }
  
    return false
  }
  
  function sanitizeHtml(unsafeHtml, whiteList) {
    if (unsafeHtml.length === 0) {
      return unsafeHtml
    }
    
    if (whiteList === undefined) {
      whiteList = DefaultWhitelist
    }

    
  
    const domParser = new window.DOMParser()
    const createdDocument = domParser.parseFromString(unsafeHtml, 'text/html')
    const whitelistKeys = Object.keys(whiteList)
    const elements = [].slice.call(createdDocument.body.querySelectorAll('*'))
  
    for (let i = 0, len = elements.length; i < len; i++) {
      const el = elements[i]
      const elName = el.nodeName.toLowerCase()  
      if (whitelistKeys.indexOf(el.nodeName.toLowerCase()) === -1) {
        el.parentNode.removeChild(el)
        continue
      }
  
      const attributeList = [].slice.call(el.attributes)
      const whitelistedAttributes = [].concat(whiteList['*'] || [], whiteList[elName] || [])
  
      attributeList.forEach((attr) => {
        if (!allowedAttribute(attr, whitelistedAttributes)) {
          el.removeAttribute(attr.nodeName)
        }
      })
    }
     
    return createdDocument.body.innerHTML
  }

window.sanitizeHtml = sanitizeHtml;
window.DefaultWhitelist = DefaultWhitelist;
  
  