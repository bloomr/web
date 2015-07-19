makerAddthis = function () {
    for (var i in window) {
        if (/^addthis/.test(i) || /^_at/.test(i)) {
            delete window[i];
        }
    }
    window.addthis_share = null;

    // AddThis config
    var layersConfig = {
        'theme': 'transparent',
        'share': {
            'position': 'right',
            'numPreferredServices': 4
        }
    };

    $.getScript("//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-53bbc57061dd9f56", function () {
        addthis.layers(layersConfig);
    });
};

document.addEventListener('page:change', function() {
    makerAddthis();
});