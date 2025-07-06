/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/**
 * Select2 Utility Functions
 * Common functions to handle Select2 initialization and nice-select conflicts
 */

// Global function to disable nice-select and initialize Select2
function initializeSelect2() {
    // Disable nice-select initialization completely
    if (typeof $.fn.niceSelect !== 'undefined') {
        $.fn.niceSelect = function () {
            return this;
        };
    }

    // Destroy any existing Select2 instances and nice-select
    $('select').each(function () {
        if ($(this).hasClass('select2-hidden-accessible')) {
            $(this).select2('destroy');
        }
        // Remove nice-select if exists
        if ($(this).next('.nice-select').length) {
            $(this).next('.nice-select').remove();
            $(this).show();
        }
    });

    // Initialize Select2 for all select elements
    $('select').select2({
        placeholder: function () {
            return $(this).data('placeholder') || $(this).find('option:first').text() || 'Select...';
        },
        allowClear: true,
        width: '100%',
        dropdownParent: $('body')
    });
}

// Function to initialize Select2 for specific elements
function initializeSelect2ForElement(selector, options = {}) {
    const defaultOptions = {
        placeholder: 'Select...',
        allowClear: true,
        width: '100%',
        dropdownParent: $('body')
    };

    const finalOptions = Object.assign(defaultOptions, options);

    $(selector).each(function () {
        if ($(this).hasClass('select2-hidden-accessible')) {
            $(this).select2('destroy');
        }
        // Remove nice-select if exists
        if ($(this).next('.nice-select').length) {
            $(this).next('.nice-select').remove();
            $(this).show();
        }
    });

    $(selector).select2(finalOptions);
}

// Function to safely destroy Select2
function destroySelect2(selector) {
    $(selector).each(function () {
        if ($(this).hasClass('select2-hidden-accessible')) {
            $(this).select2('destroy');
        }
    });
}

// Document ready initialization
$(document).ready(function () {
    // Only initialize if Select2 is available
    if (typeof $.fn.select2 !== 'undefined') {
        initializeSelect2();
    }
});