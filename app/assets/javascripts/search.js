/**
 * Created by slehericey on 08/03/15.
 */

(function() {

    var charMap = {
        "à": "a",
        "á": "a",
        "â": "a",
        "é": "e",
        "è": "e",
        "ê": "e",
        "ë": "e",
        "É": "e",
        "ï": "i",
        "î": "i",
        "ô": "o",
        "ö": "o",
        "û": "u",
        "ù": "u",
        "ü": "u",
        "ñ": "n"
    };

    var normalize = function (input) {
        $.each(charMap, function (unnormalizedChar, normalizedChar) {
            var regex = new RegExp(unnormalizedChar, 'gi');
            input = input.replace(regex, normalizedChar);
        });
        return input;
    };

    var queryTokenizer = function (q) {
        var normalized = normalize(q);
        return Bloodhound.tokenizers.whitespace(normalized);
    };

    var jobs = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('normalized'),
        queryTokenizer: queryTokenizer,
        prefetch: {
            url: '/api/v1/users',
            filter: function(array) {
                return $.map(array, function (el) {
                    // Normalize the name - use this for searching
                    el.normalized = normalize(el.job_title);
                    return el;
                });
            }
        }
    });

    var keywords = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('normalized'),
        queryTokenizer: queryTokenizer,
        prefetch: {
            url: '/api/v1/keywords',
            filter: function(array) {
                return $.map(array, function (el) {
                    // Normalize the name - use this for searching
                    el.normalized = normalize(el.tag);
                    return el;
                });
            }
        }
    });

    // kicks off the loading/processing of `local` and `prefetch`
    jobs.initialize();
    keywords.initialize();

    $(function() {
        var $mobileSearch = $('.mobile-search .version2');

        var mobileSearchActive = false;

        $('a.searchButton').on('click', function(event) {
            event.preventDefault();
            if (!mobileSearchActive) {
                console.log('Displaying mobile search');
                $mobileSearch.show('fast');
                mobileSearchActive = true;
            } else {
                console.log('Hiding mobile search');
                $mobileSearch.hide('fast');
                mobileSearchActive = false;
            }
        });

        var $search = $('.search-box');
        $search.typeahead({hint : false},{
            name: 'job_title',
            displayKey: function(el) { return el.first_name + " - " + el.job_title; },
            // `ttAdapter` wraps the suggestion engine in an adapter that
            // is compatible with the typeahead jQuery plugin
            source: jobs.ttAdapter(),
            templates: {
                header: '<h5 style="margin-left: 10px; font-weight: bold; color: #7a7a7a;">Métier</h5>'
            }
        },{
            name: 'keyword',
            displayKey: function(el) { return el.tag + " (" + el.popularity + ")"; },
            source: keywords.ttAdapter(),
            templates: {
                header: '<h5 style="margin-left: 10px; font-weight: bold; color: #7a7a7a;">Mot-Clé</h5>'
            }
        });

        $search.on('typeahead:selected', function(ev, datum, name){
            // The text typed by the user (before he clicked on an autocompleted suggestion) is stored in an invisible <pre/> next to the input. We extract it for the analytics.
            var prefix = $search.next('pre').html();
            var searchEvent = {
                prefix: prefix,
                type: name,
                referrer: document.referrer,
                datum: datum
            };

            // Send the event to Keen.io
            window.keenClient.addEvent('search', searchEvent, function(err, res) {
                if (name == 'keyword') {
                    window.location = '/tag/' + datum.tag;
                } else if (name == 'job_title') {
                    window.location = '/portraits/' + datum.id;
                }
            });

        });

        if(!Modernizr.touch) {
            $search.focus();
        }

    });

})();