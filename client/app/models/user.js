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
  doAuthorize: attr('boolean'),
  isPhotoUploaded: Ember.computed('avatarUrl', function() {
    let avatarUrl = this.get('avatarUrl');
    return avatarUrl !== 'missing_thumb.png' && avatarUrl !== '';
  }),
  isFirstQuestionsAnswered: Ember.computed('questions.@each.hasDirtyAttributes', function() {
    return this.get('questions')
      .filter((q) => q.get('step') === 'first_interview')
      .every((q) => q.get('answer') && !q.get('hasDirtyAttributes'));
  }),
  isFirstInterviewAnswered: Ember.computed('doAuthorize', 'jobTitle', 'isFirstQuestionsAnswered', function(){
    return  this.get('doAuthorize') && this.get('jobTitle') && this.get('isFirstQuestionsAnswered');
  })
});
