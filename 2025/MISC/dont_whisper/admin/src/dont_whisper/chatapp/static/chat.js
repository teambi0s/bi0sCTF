async function sendMessage(event) {
    event.preventDefault();
    const userInput = document.getElementById("user-input").value;
    if (!userInput.trim()) return;

    // Append user's message to the chat log
    appendMessage("user", userInput);

    try {
        const response = await fetch("/api/chat", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: new URLSearchParams({ user_text: userInput })
        });
        const data = await response.json();
        if (!response.ok) throw new Error(data.error || "Unknown error occurred");

        // Append AI response to the chat log
        appendMessage("agent", data.response);
        document.getElementById("user-input").value = "";
    } catch (error) {
        appendMessage("agent", `Error: ${error.message}`);
    }
}

async function sendAudio(event) {
    event.preventDefault();
    const audioInput = document.getElementById("audio-input").files[0];
    if (!audioInput) {
        appendMessage("agent", "Please select an audio file.");
        return;
    }

    // Indicate that audio was sent in chat log
    appendMessage("user", "[Holo-Recording Sent]");

    const formData = new FormData();
    formData.append("audio", audioInput);

    try {
        const response = await fetch("/api/audio-chat", {
            method: "POST",
            body: formData
        });
        const data = await response.json();
        if (!response.ok) throw new Error(data.error || "Unknown error occurred");

        // Append transcription and AI response to the chat log
        appendMessage("user", `[Transcription]: ${data.transcription}`);
        appendMessage("agent", data.response);
        document.getElementById("audio-input").value = "";
    } catch (error) {
        appendMessage("agent", `Error: ${error.message}`);
    }
}

function appendMessage(sender, message) {
    const chatLog = document.getElementById("chat-log");
    const messageDiv = document.createElement("div");
    messageDiv.className = sender === "user" ? "user-message" : "agent-message";
    messageDiv.textContent = message;
    chatLog.appendChild(messageDiv);
    chatLog.scrollTop = chatLog.scrollHeight;
}
