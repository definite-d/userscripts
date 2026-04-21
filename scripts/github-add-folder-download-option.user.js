// ==UserScript==
// @name         GitHub Folder Download
// @namespace    https://github.com/definite-d/userscripts
// @version      1.1.1
// @description  Adds "Download this folder" directly into GitHub's native Code / More options menu using the current Primer ActionList structure.
// @author       Afam-Ifediogor, U. Divine
// @license      MIT
// @homepageURL  https://github.com/definite-d/userscripts
// @supportURL   https://github.com/definite-d/userscripts/issues
// @updateURL    https://raw.githubusercontent.com/definite-d/userscripts/main/scripts/github-add-folder-download-option.user.js
// @downloadURL  https://raw.githubusercontent.com/definite-d/userscripts/main/scripts/github-add-folder-download-option.user.js
// @icon         https://github.com/favicon.ico
// @match        https://github.com/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(function () {
  "use strict";

  const DOWNLOAD_SERVICE = "https://download-directory.github.io/?url=";

  function isFolderView() {
    return /github\.com\/[^/]+\/[^/]+\/tree\//.test(location.href);
  }

  function getCurrentFolderPath() {
    const match = location.pathname.match(/\/tree\/[^/]+\/(.+)/);
    return match ? match[1] : "";
  }

  function createDownloadItem() {
    const item = document.createElement("li");
    item.className = "prc-ActionList-ActionListItem-So4vC";
    item.setAttribute("role", "none");
    item.setAttribute("data-folder-download", "true");

    const link = document.createElement("a");
    link.className =
      "prc-ActionList-ActionListContent-KBb8- prc-Link-Link-9ZwDx";
    link.setAttribute("role", "menuitem");
    link.setAttribute("tabindex", "-1");
    link.setAttribute("data-size", "medium");

    // Build the download URL
    const folderUrl = encodeURIComponent(location.href);
    link.href = DOWNLOAD_SERVICE + folderUrl;
    link.target = "_blank";
    link.rel = "noopener noreferrer";

    link.innerHTML = `
            <span class="prc-ActionList-ActionListSubContent-gKsFp" data-component="ActionList.Item--DividerContainer">
                <span class="prc-ActionList-ItemLabel-81ohH">Download this folder</span>
            </span>
        `;

    item.appendChild(link);
    return item;
  }

  function addDownloadOption() {
    if (!isFolderView()) return;

    const folderPath = getCurrentFolderPath();
    if (!folderPath) return; // Skip root (already has full repo Download ZIP)

    // Target the main ActionList ul in the portal / dropdown
    const menu = document.querySelector(
      'ul.prc-ActionList-ActionList-rPFF2[role="menu"]',
    );
    if (!menu) return;

    // Prevent duplicates
    if (menu.querySelector("[data-folder-download]")) return;

    const downloadItem = createDownloadItem();

    // Find the "Delete directory" item to insert before its preceding divider
    const deleteDirectoryLink = menu.querySelector('a[href*="/tree/delete/"]');
    const deleteDirectoryItem = deleteDirectoryLink?.closest("li");

    if (deleteDirectoryItem) {
      // Insert before the divider that comes before Delete directory
      const divider = deleteDirectoryItem.previousElementSibling;
      if (
        divider &&
        divider.classList.contains("prc-ActionList-Divider-taVfb")
      ) {
        menu.insertBefore(downloadItem, divider);
      } else {
        menu.insertBefore(downloadItem, deleteDirectoryItem);
      }
    } else {
      // Fallback: insert before the "View options" group
      const viewOptionsGroup = menu.querySelector(
        "li.prc-ActionList-Group-lMIPQ",
      );
      if (viewOptionsGroup) {
        menu.insertBefore(downloadItem, viewOptionsGroup);
      } else {
        menu.appendChild(downloadItem);
      }
    }
  }

  // Initial run
  addDownloadOption();

  // GitHub is a heavy SPA — observe DOM changes
  const observer = new MutationObserver(() => {
    setTimeout(addDownloadOption, 250);
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true,
  });

  // Also listen for popstate / URL changes (folder navigation)
  window.addEventListener("popstate", () => {
    setTimeout(addDownloadOption, 300);
  });
})();
