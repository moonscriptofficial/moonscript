/**
 * @file live-reload.js
 * @author Krisna Pranav
 * @brief Live Reload Functionality
 * @version 1.0
 * @date 2024-02-07
 * 
 * @copyright Copyright (c) 2025 Krisna Pranav, Moon Developers
 * 
 */

(function connect(reload = false) {
    let closing = false;

    window.addEventListener("beforeunload", () => {
        closing = true;
    });

    var ws = new WebSocket("ws://" + location.host);

    ws.onopen = () => {
        if (reload) {
            window.location.reload();
        }
    };

    ws.onclose = () => {
        if (!closing) {
            setTimeout(() => connect(true), 200);
        }
    };

    ws.onmessage = msg => {
        if (msg.data == "reload") {
            window.location.reload();
        }
    };
})();