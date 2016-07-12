import Model from 'ember-data/model';
import attr from 'ember-data/attr';

export default Model.extend({
  author: attr('string'),
  isbn: attr('string'),
  title: attr('string'),
  imageUrl: attr('string')
});
