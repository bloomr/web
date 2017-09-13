(function() {
  var url = 'https://public-api.wordpress.com/rest/v1.1/sites/blog.bloomr.org/posts/?number=3&fields=title,URL,featured_image,date';

  var buildTemplate = function (post) {
    return '<li>' + 
      "<a href='" + post.URL + "'>" + 
      '<span class="date">' + (new Date(post.date)).toLocaleDateString() + '</span>' +
      '<h1>' + post.title + '</h1>' +
      '<img height="104px" src="' + post.featured_image + '">' +
      "<span class='go'>→&nbsp;Lire l'article</span>" +
      '</a>' +
      '</li>';
  };

  var injectTemplate = function (template) {
    return $('.blog-posts').append(template);
  };

  var processData = function (data) {
    _.chain(data.posts)
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
