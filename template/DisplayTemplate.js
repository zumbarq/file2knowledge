// renderMarkdown.js
(() => {
  // 'md' doit être défini avant d'exécuter ce script, par exemple :
  //   window.md = "## Mon markdown…";
  // ou en passant md en global depuis votre host.
  const md   = %s;
  const html = marked.parse(md);
  const root = document.getElementById("ResponseContent");
  root.innerHTML = html;

  document
    .querySelectorAll("pre > code[class^=\"language-\"]")
    .forEach(codeEl => {
      const pre  = codeEl.parentNode;
      const lang = codeEl.className.replace("language-", "");

      // Container et header
      const container = document.createElement("div");
      container.className = "code-container";

      const header = document.createElement("div");
      header.className  = "code-header";
      header.textContent = lang.toUpperCase();

      // Bouton Copy
      const btn = document.createElement("button");
      btn.className  = "copy-btn";
      btn.textContent = "Copy";
      header.appendChild(btn);

      // Insertion dans le DOM
      pre.parentNode.insertBefore(container, pre);
      container.appendChild(header);
      container.appendChild(pre);

      // Gestion du clic
      btn.onclick = () => {
        if (navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(codeEl.textContent)
            .catch(() => {
              const ta = document.createElement("textarea");
              ta.value = codeEl.textContent;
              document.body.appendChild(ta);
              ta.select();
              document.execCommand("copy");
              ta.remove();
            });
        } else {
          const ta = document.createElement("textarea");
          ta.value = codeEl.textContent;
          document.body.appendChild(ta);
          ta.select();
          document.execCommand("copy");
          ta.remove();
        }

        // Message vers WebView (si utilisé)
        if (window.chrome && window.chrome.webview && window.chrome.webview.postMessage) {
          window.chrome.webview.postMessage({
            event: "copy",
            lang: lang,
            text: codeEl.textContent
          });
        }
      };

      // Highlight.js
      if (window.hljs) window.hljs.highlightElement(codeEl);
    });

  // Scroll tout en bas
  // window.scrollTo(0, document.body.scrollHeight);
})();

