document.addEventListener("DOMContentLoaded", () => {
    const customContext = document.querySelector(".customContext")

    document.addEventListener("click", (event) => {
        if (!event.target.closest(".threeDot")) {
            customContext.style.display = "none";
        }
    });
});

function openMenu(event) {
    const customContext = document.querySelector(".customContext");

    const messageDiv = event.target.closest('.message');
    if (messageDiv) {
        customContext.style.display = "flex";
        console.log(event.pageX, event.pageY);
        customContext.style.left = `${event.pageX}px`;
        customContext.style.top = `${event.pageY}px`;
        
        customContext.dataset.idx = messageDiv.dataset.msgId;
        const current = document.querySelector(`.message[data-msg-id="${customContext.dataset.idx}"]`);
        current.dataset.check = 1;
    }

    return true;
}
