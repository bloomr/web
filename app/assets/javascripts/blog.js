(function() {
  var url = 'https://blog-bloomr.org/wp-json/wp/v2/posts';

  var buildTemplate = function (post) {
    return '<li>' +
      "<a href='" + post.link + "'>" +
      '<span class="date">' + (new Date(post.date)).toLocaleDateString() + '</span>' +
      '<h1>' + post.title.rendered + '</h1>' +
      "<span class='go'>→&nbsp;Lire l'article</span>" +
      '</a>' +
      '</li>';
  };

  var injectTemplate = function (template) {
    return $('.blog-posts').append(template);
  };

  var processData = function (data) {
    _.chain(data.slice(0, 3))
      .map(buildTemplate)
      .each(injectTemplate);
  };

  var fetchDataFromBlog = function (data) {
    if($('#home').length !== 0) {
      if($('.blog-posts').is(':empty')) {
        $.get(url, processData);
      }
    }
  };

  document.addEventListener('turbolinks:load', fetchDataFromBlog);
})();
