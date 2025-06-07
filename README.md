// ==UserScript==
// @name         BestPilot - تثبيت اتجاه الطائرة (صعود / هبوط)
// @namespace    http://tampermonkey.net/
// @version      1.2
// @description  يعرض اتجاه الطائرة في أعلى الشاشة ويثبت آخر اتجاه معروف عند التوقف
// @match        https://www.bestpilot.club/*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    let canvas = null;
    let ctx = null;
    let overlay = null;
    let lastDirection = "";
    let lastColor = "";

    function createOverlay() {
        overlay = document.createElement('div');
        overlay.style.position = 'fixed';
        overlay.style.top = '0';
        overlay.style.left = '0';
        overlay.style.width = '100%';
        overlay.style.textAlign = 'center';
        overlay.style.padding = '12px 0';
        overlay.style.fontSize = '30px';
        overlay.style.fontFamily = 'Arial, sans-serif';
        overlay.style.fontWeight = 'bold';
        overlay.style.zIndex = '9999';
        overlay.style.color = 'white';
        overlay.style.backgroundColor = 'transparent';
        document.body.appendChild(overlay);
    }

    function updateOverlay(text, bgColor) {
        if (overlay) {
            overlay.innerText = text;
            overlay.style.backgroundColor = bgColor;
        }
    }

    function findWhiteObjectPosition() {
        if (!canvas) return null;
        const w = canvas.width;
        const h = canvas.height;
        const imageData = ctx.getImageData(0, 0, w, h);
        const data = imageData.data;

        for (let y = 0; y < h; y += 2) {
            for (let x = 0; x < w; x += 2) {
                const i = (y * w + x) * 4;
                const r = data[i];
                const g = data[i + 1];
                const b = data[i + 2];
                if (r > 240 && g > 240 && b > 240) {
                    return { x, y };
                }
            }
        }
        return null;
    }

    function startTracking() {
        createOverlay();
        let prevPos = null;

        setInterval(() => {
            const currentPos = findWhiteObjectPosition();
            if (currentPos && prevPos) {
                const dy = currentPos.y - prevPos.y;

                if (dy > 2) {
                    lastDirection = "⬇️ الطائرة تهبط";
                    lastColor = "#e74c3c";
                } else if (dy < -2) {
                    lastDirection = "⬆️ الطائرة تصعد";
                    lastColor = "#2ecc71";
                }

                if (lastDirection) {
                    updateOverlay(lastDirection, lastColor);
                }
            }

            prevPos = currentPos;
        }, 200);
    }

    const tryInit = setInterval(() => {
        canvas = document.querySelector("canvas");
        if (canvas) {
            ctx = canvas.getContext("2d");
            clearInterval(tryInit);
            startTracking();
            console.log("✅ السكريبت يعمل: يتم تتبع اتجاه الطائرة.");
        }
    }, 1000);
})();
