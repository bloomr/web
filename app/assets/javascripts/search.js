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
                $mobileSearch.show('fast');
                $('input', $mobileSearch).focus();
                mobileSearchActive = true;
            } else {
                $mobileSearch.hide('fast');
                mobileSearchActive = false;
            }
        });

        var $search = $('.search-box');
        $search.typeahead({hint : false},{
            name: 'job_title',
            displayKey: function(el) {

                var find_good_question = function (el) {
                    var question = _.find(el._snippetResult.questions, function(q){ return q.answer.matchLevel == 'full' });
                    if(question){
                        return '"... ' + question.answer.value + ' ..."';
                    } else {
                        return '';
                    }
                };


                return el.first_name + " - " + el.job_title + "</br>" + find_good_question(el);
            },
            // `ttAdapter` wraps the suggestion engine in an adapter that
            // is compatible with the typeahead jQuery plugin
            source: window.algolia.usersIndex.ttAdapter({hitsPerPage: 5, attributesToSnippet: 'job_title:20,questions:15'}),
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

        $search.on('typeahead:selected', function (ev, datum, name) {

            if (name == 'keyword') {
                window.location = '/tag/' + datum.tag;
            } else if (name == 'job_title') {
                window.location = '/portraits/' + datum.objectID;
            }

        });

        if(!Modernizr.touch) {
            $search.focus();
        }

    });

})();