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

        var $search = $('#search');
        $search.typeahead(null,{
            name: 'job_title',
            displayKey: function(el) { return el.first_name + " - " + el.job_title; },
            // `ttAdapter` wraps the suggestion engine in an adapter that
            // is compatible with the typeahead jQuery plugin
            source: jobs.ttAdapter(),
            templates: {
                header: '<h5 style="margin-left: 10px; font-weight: bold; color: #7a7a7a;">Métier</h5>'
            }
        },{
            name: 'keywords',
                displayKey: function(el) { return el.tag + " (" + el.popularity + ")"; },
            source: keywords.ttAdapter(),
            templates: {
                header: '<h5 style="margin-left: 10px; font-weight: bold; color: #7a7a7a;">Mot-Clé</h5>'
            }
            }
        );

        $search.on('typeahead:selected', function(ev, data){
            if(data.tag) {
                window.location = '/tag/' + data.tag;
            } else if(data.job_title) {
                window.location = '/portraits/' + data.id;
            }
        });

        if(!Modernizr.touch) {
            $search.focus();
        }

    });

})();