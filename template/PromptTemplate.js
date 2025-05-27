// Create a bubble fot the prompt
(() => {
    const root = document.getElementById("ResponseContent");
    const bubble = document.createElement("div");
    bubble.className = "chat-bubble user";
    bubble.style.whiteSpace = "pre-wrap";
    bubble.textContent = %s;
    root.appendChild(bubble);
    // window.scrollTo(0, document.body.scrollHeight);
    setTimeout(() => {
        window.scrollTo(0, document.body.scrollHeight);
    }, 0);
  })();
