/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


// Disable nice-select completely
(function () {
    'use strict';

    // Override nice-select function to prevent it from running
    if (typeof jQuery !== 'undefined') {
        jQuery.fn.niceSelect = function () {
            return this; // Return the original element without doing anything
        };
    }

    // Remove any existing nice-select elements
    function removeNiceSelect() {
        if (typeof jQuery !== 'undefined') {
            jQuery('.nice-select').remove();
            jQuery('select').removeClass('nice-select-processed');
        }
    }

    // Run removal when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', removeNiceSelect);
    } else {
        removeNiceSelect();
    }

    // Also run removal when window loads (as backup)
    window.addEventListener('load', removeNiceSelect);

    // Observe for any dynamically added nice-select elements and remove them
    if (typeof MutationObserver !== 'undefined') {
        var observer = new MutationObserver(function (mutations) {
            mutations.forEach(function (mutation) {
                if (mutation.type === 'childList') {
                    mutation.addedNodes.forEach(function (node) {
                        if (node.nodeType === 1) { // Element node
                            if (node.classList && node.classList.contains('nice-select')) {
                                node.remove();
                            }
                            // Also check children
                            var niceSelects = node.querySelectorAll && node.querySelectorAll('.nice-select');
                            if (niceSelects) {
                                niceSelects.forEach(function (el) {
                                    el.remove();
                                });
                            }
                        }
                    });
                }
            });
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    }
})();
