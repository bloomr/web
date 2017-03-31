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
  strengths: hasMany('strength'),
  keywords: hasMany('keyword'),
  avatarUrl: attr('string'),
  doAuthorize: attr('boolean'),
  isPhotoUploaded: Ember.computed('avatarUrl', function() {
    let avatarUrl = this.get('avatarUrl');
    return avatarUrl.indexOf('missing') !== 0 && avatarUrl !== '';
  }),
  isFirstQuestionsAnswered: Ember.computed('questions.@each.answer', function() {
    return this.get('questions')
      .filterBy('step', 'first_interview')
      .filterBy('mandatory', true)
      .every(q => q.get('answer') && q.get('answer') !== '');
  }),
  isFirstInterviewAnswered: Ember.computed('doAuthorize', 'jobTitle', 'isFirstQuestionsAnswered', function(){
    return  this.get('doAuthorize') && this.get('jobTitle') && this.get('isFirstQuestionsAnswered');
  }),

  questions_by_step(step) {
    return this.get('questions')
      .then(questions => questions.filterBy('step', step));
  },
  addChallenge(challenge) {
    return this.get('challenges')
      .then(userChallenges => userChallenges.addObject(challenge))
      .then(() => this);
  },
  removeChallenge(challenge) {
    return this.get('challenges')
      .then(userChallenges => userChallenges.removeObject(challenge))
      .then(() => this);
  },
  setTribes(tribes) {
    return this.get('tribes')
      .then(userTribes => userTribes.setObjects(tribes))
      .then(() => this);
  },
  setBooks(books) {
    return this.get('books')
      .then(userBooks => userBooks.setObjects(books))
      .then(() => this);
  },
  setStrengths(strengths) {
    return this.get('strengths')
      .then(userStrengths => userStrengths.setObjects(strengths))
      .then(() => this);
  },
});
