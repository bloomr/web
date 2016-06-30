import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { hasMany } from 'ember-data/relationships';
import Ember from 'ember';

export default Model.extend({
  jobTitle: attr('string'),
  firstName: attr('string'),
  tribes: hasMany('tribe'),
  books: hasMany('book'),
  stats: attr(),
  questions: hasMany('question'),
  challenges: hasMany('challenge'),
  avatarUrl: attr('string'),
  isPhotoUploaded: Ember.computed('avatarUrl', function() {
    return this.get('avatarUrl') !== 'missing_thumb.png';
  }),
  isFirstQuestionsAnswered: Ember.computed('questions.@each.hasDirtyAttributes', function() {
    return this.get('questions').filter((q) => q.get('answer') && !q.get('hasDirtyAttributes')).length > 4;
  })
});
