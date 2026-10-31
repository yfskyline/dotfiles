// ==UserScript==
// @name         HackMD: Fix Esc in multi-cursor mode
// @namespace    https://hackmd.io/
// @version      1.0.2
// @description  Restore CodeMirror's Esc behavior
// @match        https://hackmd.io/*
// @run-at       document-idle
// @grant        none
// @sandbox      raw
// @noframes
// @updateURL    https://raw.githubusercontent.com/yfskyline/dotfiles/master/chrome/tampermonkey/hackmd-multicursor-fix.user.js
// @downloadURL  https://raw.githubusercontent.com/yfskyline/dotfiles/master/chrome/tampermonkey/hackmd-multicursor-fix.user.js
// ==/UserScript==

(() => {
  'use strict';

  const key = '__hackmdEscMulticursorFix';
  window[key]?.stop?.();

  function handleKeydown(e) {
    if (
      e.key !== 'Escape' ||
      e.isComposing ||
      e.keyCode === 229 ||
      e.ctrlKey || e.altKey || e.metaKey || e.shiftKey ||
      e.defaultPrevented
    ) return;

    const input = document.activeElement;
    const wrapper = input?.closest?.('.CodeMirror');
    const cm = wrapper?.CodeMirror;

    if (
      !cm ||
      typeof cm.getInputField !== 'function' ||
      typeof cm.listSelections !== 'function' ||
      typeof cm.execCommand !== 'function' ||
      cm.getInputField() !== input ||
      cm.listSelections().length <= 1
    ) return;

    e.preventDefault();
    e.stopImmediatePropagation();
    cm.execCommand('singleSelectionTop');
  }

  window.addEventListener('keydown', handleKeydown, true);

  window[key] = {
    stop() {
      window.removeEventListener('keydown', handleKeydown, true);
      delete window[key];
    }
  };

  console.info('[HackMD Esc Fix] active');
})();
