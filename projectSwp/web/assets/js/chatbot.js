/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {
    const toggleBtn = document.getElementById("chatbot-toggle");
    const chatbotBox = document.getElementById("chatbot-box");
    const chatMessages = document.getElementById("chat-messages");
    const userInput = document.getElementById("user-input");
    const sendBtn = document.getElementById("send-button");

    toggleBtn.addEventListener("click", function () {
        chatbotBox.classList.toggle("hidden");
    });

    sendBtn.addEventListener("click", function () {
        sendMessage();
    });

    userInput.addEventListener("keydown", function (e) {
        if (e.key === "Enter" && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });

    function sendMessage() {
        const message = userInput.value.trim();
        if (message === "") return;

        appendMessage("Bạn", message, true);
        userInput.value = "";

        const xhr = new XMLHttpRequest();
        xhr.open("POST", "chatbot", true); // đổi đường dẫn nếu servlet khác
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    appendMessage("Bot", xhr.responseText, false);
                } else {
                    appendMessage("Bot", "❌ Lỗi máy chủ.", false);
                }
            }
        };

        xhr.send("message=" + encodeURIComponent(message));
    }

    function appendMessage(sender, text, isUser) {
        const msg = document.createElement("div");
        msg.className = "message " + (isUser ? "user" : "bot");
        msg.innerHTML = `<strong>${sender}:</strong> ${text}`;
        chatMessages.appendChild(msg);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
});
