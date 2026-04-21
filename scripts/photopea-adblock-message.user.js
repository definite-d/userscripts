// ==UserScript==
// @name         Remove Photopea Adblock Nag
// @namespace    http://tampermonkey.net/
// @version      1.0.3
// @description  Removes the nag that says "Something is changing our code..."
// @author       Afam-Ifediogor, U. Divine
// @match        https://www.photopea.com/
// @icon         https://www.google.com/s2/favicons?sz=64&domain=photopea.com
// @grant        none
// ==/UserScript==

(function () {
  "use strict";

  const cleanNag = () => {
    // Find all panels with the alert class
    const panels = document.querySelectorAll(".alertpanel.tpanel");

    panels.forEach((panel) => {
      // Check if the text matches the specific adblock warning
      if (panel.textContent.includes("Something is changing our source code")) {
        panel.style.display = "none";
      }
    });
  };

  // Run on load
  cleanNag();

  // Watch for dynamic injections
  const observer = new MutationObserver(() => {
    cleanNag();
  });

  observer.observe(document.body, {
    childList: true,
    subtree: true,
  });
})();
