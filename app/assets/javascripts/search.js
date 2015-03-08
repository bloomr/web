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

    // kicks off the loading/processing of `local` and `prefetch`
    jobs.initialize();

    $(function() {
        $('.search').typeahead(null,{
            name: 'job_title',
            displayKey: 'job_title',
            // `ttAdapter` wraps the suggestion engine in an adapter that
            // is compatible with the typeahead jQuery plugin
            source: jobs.ttAdapter()
        });

        $('.search').on('typeahead:selected', function(ev, data){
            window.location = '/portraits/' + data.id;
        });

    });

})();