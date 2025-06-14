const api = {};
const addmsgForm = document.getElementById('add-msg');
const mymsgsDiv = document.getElementById('chat-messages');
const reportUrl = document.getElementById('report-url');

const saved = [];
const msgs = [];

const getRandomResponse = () => {
  const responses = [
    "That's interesting! Tell me more.",
    "I see. How does that make you feel?",
    "Fascinating! What do you think about that?",
    "I understand. What would you like to discuss next?",
    "That's a great point. Can you elaborate?",
    "I'm not sure I follow. Could you explain that differently?",
    "Interesting perspective! Have you considered the alternative?",
    "I appreciate you sharing that. What led you to that conclusion?",
    "That's quite thought-provoking. How did you come to that realization?",
    "I'm curious to hear more about your thoughts on this topic."
  ];
  return responses[Math.floor(Math.random() * responses.length)];
};

const messagesToHTML = (messages) => {
  return messages.map((msg, idx) => `
    <div class="message user-message" data-msg-id="${idx}">
      <b>You</b><br><br>
      <button onclick="openMenu(event)" class="threeDot">&vellip;</button>
      <div class="message-content">${msg.content}</div>
      <span class="left">${new Date(msg.time).toLocaleString()}</span>
    </div>
    <div class="message bot-message" data-msg-id="${idx}">
      <b>Wasp</b><br><br>
      ${getRandomResponse()}
      <span class="right">${new Date(msg.time).toLocaleString()}</span>
    </div>
  `).join('');
};


const rendermsgs = () => {
  const html = msgs.length > 0 ? messagesToHTML(msgs) : '<p class="noMessage">No messages yet</p>';
  mymsgsDiv.innerHTML = html;
  const editButtons = document.querySelectorAll('.edit-btn');
  const deleteButtons = document.querySelectorAll('.delete-btn');
  const renderButtons = document.querySelectorAll('.render-btn');
  const renderTextButtons = document.querySelectorAll('.text-btn');


  renderButtons.forEach((button) => {
    button.addEventListener('click', (e) => {
      const msgId = parseInt(e.target.parentElement.dataset.idx);
      console.log(`Rendering message with ID: ${msgId}`);
      const check = document.querySelector(`.message[data-msg-id="${msgId}"]`).dataset.check;

      if (check == 1) {
        api.renderHtml(msgId,api.renderCallback);
      }
    });
  });

  renderTextButtons.forEach((button) => {
    button.addEventListener('click', (e) => {
      const msgId = parseInt(e.target.parentElement.dataset.idx);
      console.log(`Rendering message with ID: ${msgId}`);
      const check = document.querySelector(`.message[data-msg-id="${msgId}"]`).dataset.check;

      if (check == 1) {
        api.renderText(msgId,api.renderCallback);
      }
    });
  });
  
  editButtons.forEach((button) => {
    button.addEventListener('click', (e) => {
      const msgId = parseInt(e.target.parentElement.dataset.idx);
      const messageDiv = document.querySelector(`.message[data-msg-id="${msgId}"]`);
      const contentDiv = messageDiv.querySelector(".message-content");
      const currentContent = contentDiv.textContent;

      Swal.fire({
        title: 'Edit Message',
        input: 'text',
        inputAttributes: {
          id: 'edit-message',
          placeholder: 'Enter Message...'
        },
        inputValue: currentContent,
        showCancelButton: true,
        confirmButtonText: 'Save',
        cancelButtonText: 'Cancel',
        preConfirm: (newContent) => {
          if (!newContent) {
            Swal.showValidationMessage('The message cannot be empty.');
          }
          return newContent;
        }
      }).then((result) => {
        if (result.isConfirmed && result.value.trim() !== currentContent) {
          const newContent = result.value.trim();
          editMsg(msgId, newContent, new Date().getTime());
        }
      });
    });
  });


  deleteButtons.forEach((button) => {
    button.addEventListener('click', (e) => {
      const msgId = parseInt(e.target.parentElement.dataset.idx);
      const check = document.querySelector(`.message[data-msg-id="${msgId}"]`).dataset.check;

      if (check == 1) {
        api.deletemsg(msgId,api.deletemsgCallback);
      }
    });
  });
};


const addmsg = (content,time, isBatched = false) => {
  saved.push({
    'action': 'add',
    'content': content,
    'time' : time,
  })
  reportUrl.href = `${window.location.origin}?s=${btoa(JSON.stringify(saved))}`;

  const msgId = api.addmsg(
    content,
    content.length,
    time,
    0 
  );
  if (msgId < 0) {
    console.log('msg was too long!');
    return;
  }
  if (!isBatched) {
    api.populateMsgs(api.populateMsgsCallback);
    rendermsgs();
  }
}



const populateMsgs = (msgHTML, status, time, idx) => {
  msgs[idx] = {
    'content': UTF8ToString(msgHTML),
    'status': status,
    'time': time
  }
  return 0;
}

const render = (msgHTML, status, time, idx) => {
  msgs[idx] = {
    'content': UTF8ToString(msgHTML),
    'status': status,
    'time': time
  }
  rendermsgs();
  return 0;
}

const deletemsg = (msgId, isBatched = false) => {
  saved.push({
    'action': 'delete',
    'msgId': msgId
  })
  reportUrl.href = `${window.location.origin}?s=${btoa(JSON.stringify(saved))}`;

  if (!isBatched) {
    msgs.splice(msgId, 1);
    rendermsgs();
  }
}

const editMsg = (msgId, content,time ,isBatched = false) => {
  saved.push({
    'action':'edit',
    'msgId': msgId,
    'content':content,
    'time':time
  })
  reportUrl.href = `${window.location.origin}?s=${btoa(JSON.stringify(saved))}`;
  const flag = api.editMsg(
    msgId,
    content,
    content.length,
    time
  )
  
  if (flag < 0) {
    console.log('msg was too long!');
    return;
  }
  if (!isBatched) {
    api.populateMsgs(api.populateMsgsCallback);
    rendermsgs();
  }
} 

const main = () => {
  api.initialize();
  const addmsgForm = document.getElementById('add-msg');
  addmsgForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const content = document.getElementById('user-input').value;
    addmsg(content, new Date().getTime())
    addmsgForm.reset();
  })

  serialized = new URLSearchParams(window.location.search).get('s');
  if (serialized) {
    todo = JSON.parse(atob(serialized));

    todo.forEach((step) => {
      if (step.action == 'add') {
        addmsg(
          step.content,
          step.time,
          true
        );
      } else if (step.action == 'delete') {
        api.deletemsg(
          step.msgId,
          api.deletemsgCallback
        );
      } else if (step.action == 'edit'){
        editMsg(
          step.msgId,
          step.content,
          step.time,
          true
        )
      }
      api.populateMsgs(api.populateMsgsCallback);
      rendermsgs();
    });
  }
}

Module.onRuntimeInitialized = async (_) => {
  api.populateMsgsCallback = Module.addFunction(populateMsgs, 'iiiii');
  api.deletemsgCallback = Module.addFunction(deletemsg, 'vi');
  api.renderCallback = Module.addFunction(render, 'iiiii');

  api.addmsg = Module.cwrap('addMsg', 'number', ['string', 'number', 'number', 'number']);
  api.deletemsg = Module.cwrap('deleteMsg', 'number', ['number', 'number']);
  api.populateMsgs = Module.cwrap('populateMsgHTML', null, ['number']);
  api.editMsg = Module.cwrap('editMsg', 'number', ['number', 'string', 'number', 'number']);
  api.renderHtml = Module.cwrap('renderHtml', null, ['number','number']);
  api.renderText = Module.cwrap('renderText', null, ['number','number']);
  api.initialize = Module.cwrap('initialize', 'number', []); 

  main();
};