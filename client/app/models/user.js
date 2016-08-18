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
  keywords: hasMany('keyword'),
  avatarUrl: attr('string'),
  doAuthorize: attr('boolean'),
  isPhotoUploaded: Ember.computed('avatarUrl', function() {
    let avatarUrl = this.get('avatarUrl');
    return avatarUrl.indexOf('missing_thumb') !== 0 && avatarUrl !== '';
  }),
  isFirstQuestionsAnswered: Ember.computed('questions.@each.answer', function() {
    return this.get('questions')
      .filter(q => q.get('step') === 'first_interview')
      .every(q => q.get('answer') && q.get('answer') !== '');
  }),
  isFirstInterviewAnswered: Ember.computed('doAuthorize', 'jobTitle', 'isFirstQuestionsAnswered', function(){
    return  this.get('doAuthorize') && this.get('jobTitle') && this.get('isFirstQuestionsAnswered');
  }),

  addChallenge(challenge) {
    return this.get('challenges')
      .then(userChallenges => {
        userChallenges.addObject(challenge);
        return this;
      });
  },
  setTribes(tribe) {
    return this.get('tribes')
      .then(userTribes => {
        userTribes.setObjects(tribe);
        return this;
      });
  }
});
