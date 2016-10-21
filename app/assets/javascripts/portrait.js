(function () {
  var structure = {
    links: {
      work: '#work',
      interview: '#interview',
      books: '#books'
    },
    sections: {
      work: '#my-work',
      books: '#my-books',
      interview: '#my-interview'
    }
  };

  var show = function (elementName) {
    var toHides = _.omit(structure.sections, elementName);
    var toShow = structure.sections[elementName];
    var toDesactivates = _.omit(structure.links, elementName);
    var toActivate = structure.links[elementName];

    return function (e) {
      e.preventDefault();

      _.each(toHides, function(toHide) {
        $(toHide).hide();
      });
      $(toShow).show();

      _.each(toDesactivates, function(toDesactivate) {
        $(toDesactivate).removeClass('active');
      });
      $(toActivate).addClass('active');
    };
  };

  var bindLinks = function (structure) {
    var allElementNames = _.keys(structure.links);
    _.each(allElementNames, function (elementName) {
      $(document).on('click', '#portrait_details_2 ' + structure.links[elementName], show(elementName));
    });
  };

  bindLinks(structure);
})();
