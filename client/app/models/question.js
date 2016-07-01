import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { belongsTo } from 'ember-data/relationships';

export default Model.extend({
  title: attr('string'),
  answer: attr('string'),
  description: attr('string'),
  step: attr('string'),
  user: belongsTo('user')
});
