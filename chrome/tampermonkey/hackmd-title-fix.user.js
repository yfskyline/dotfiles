// ==UserScript==
// @name         HackMD Title Regression Fix
// @namespace    local.hackmd.fixes
// @version      0.2.0
// @description  Workaround for HackMD note metadata regression
// @match        https://hackmd.io/*
// @run-at       document-idle
// @grant        GM_addStyle
// @noframes
// ==/UserScript==

(() => {
    "use strict";

    const TAG = "[HackMD Title Fix]";
    const SELECTOR = ".ui-note-meta-title";
    const ATTR = "data-hmd-title-fix";
    const SUFFIX = " - HackMD";

    const fallbackTitles = new Set([
        "HackMD",
        "HackMD - Collaborative Markdown Knowledge Base",
        "HackMD - Markdownで知識ベースを共作"
    ]);

    const initialPath = location.pathname;

    let lastValidTitle = null;
    let patchedElement = null;
    let active = true;

    // Display the cached title without modifying React's text nodes.
    GM_addStyle(`
        ${SELECTOR}[${ATTR}] > span:only-child {
            display: none !important;
        }

        ${SELECTOR}[${ATTR}]::after {
            content: attr(${ATTR});
            padding: 1px 3px;
            white-space: pre;
        }
    `);

    function clearPatch() {
        if (patchedElement) {
            patchedElement.removeAttribute(ATTR);
            patchedElement = null;
        }
    }

    function stop() {
        active = false;
        lastValidTitle = null;
        clearPatch();

        headObserver.disconnect();
        bodyObserver.disconnect();

        console.info(TAG, "Disabled after navigation");
    }

    function reconcile() {
        if (!active) return;

        // Never apply a cached title to a different note.
        if (location.pathname !== initialPath) {
            stop();
            return;
        }

        const element = document.querySelector(SELECTOR);

        if (!element) {
            clearPatch();
            return;
        }

        if (patchedElement && patchedElement !== element) {
            clearPatch();
        }

        const span = element.querySelector(":scope > span:only-child");
        const editorTitle = span?.textContent.trim() ?? "";

        const current = document.title.trim();

        // Preserve HackMD's unread/update indicator.
        const prefix = current.match(/^[·•・]\s*/)?.[0] ?? "";
        const baseTitle = current.slice(prefix.length);

        const isFallback = fallbackTitles.has(baseTitle);
        const isValidTabTitle = baseTitle.endsWith(SUFFIX);

        // Track legitimate title changes.
        if (isValidTabTitle) {
            lastValidTitle = baseTitle.slice(0, -SUFFIX.length);
        }

        // Recover from the editor title if necessary.
        if (
            isFallback &&
            !lastValidTitle &&
            editorTitle &&
            editorTitle !== "Untitled"
        ) {
            lastValidTitle = editorTitle;
        }

        if (!lastValidTitle) return;

        // Fix the browser tab title.
        if (isFallback) {
            const restored = prefix + lastValidTitle + SUFFIX;

            if (document.title !== restored) {
                document.title = restored;
                console.info(TAG, "Browser title restored");
            }
        }

        // Fix only the visual representation of the editor title.
        // Do not modify React state or editable input fields.
        if (
            span &&
            !element.querySelector("input, textarea, [contenteditable='true']") &&
            editorTitle === "Untitled" &&
            lastValidTitle !== "Untitled" &&
            (isFallback || isValidTabTitle)
        ) {
            if (element.getAttribute(ATTR) !== lastValidTitle) {
                element.setAttribute(ATTR, lastValidTitle);
                console.info(TAG, "Editor title restored");
            }

            patchedElement = element;
        } else {
            clearPatch();
        }
    }

    // Observe browser title changes.
    const headObserver = new MutationObserver(reconcile);

    headObserver.observe(document.head, {
        childList: true,
        subtree: true,
        characterData: true
    });

    // Ignore unrelated editor DOM updates.
    function touchesTitle(record) {
        const target = record.target.nodeType === 1
            ? record.target
            : record.target.parentElement;

        if (target?.closest(SELECTOR)) {
            return true;
        }

        return [...record.addedNodes, ...record.removedNodes]
            .some(node =>
                node.nodeType === 1 &&
                (
                    node.matches(SELECTOR) ||
                    node.querySelector(SELECTOR)
                )
            );
    }

    const bodyObserver = new MutationObserver(records => {
        if (
            location.pathname !== initialPath ||
            records.some(touchesTitle)
        ) {
            reconcile();
        }
    });

    bodyObserver.observe(document.body, {
        childList: true,
        subtree: true,
        characterData: true
    });

    window.addEventListener("popstate", reconcile);

    reconcile();

    console.info(TAG, "active (v0.2.0)");
})();
