import Ember from 'ember';

export default Ember.Service.extend({
  search(keywords, options) {
    let encodedKeywords = encodeURIComponent(keywords);
    let query = '/api/v1/books/search?keywords='+encodedKeywords;

    if(options && options.inEnglish) {
      query += '&inEnglish=true';
    }
    return Ember.$.get(query);
  }
});
