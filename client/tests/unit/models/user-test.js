import { moduleForModel, test } from 'ember-qunit';
import Ember from 'ember';
import { makeList, manualSetup } from 'ember-data-factory-guy';

moduleForModel('user', 'Unit | Model | user', {
  // Specify the other units that are required for this test.
  needs: ['model:tribe', 'model:question', 'model:challenge', 'model:book']
});

test('it exists', function(assert) {
  let model = this.subject();
  assert.ok(!!model);
});

test('isPhotoUploaded is false initially', function(assert) {
  Ember.run(() => this.subject().set('avatarUrl', 'missing_thumb.png-0123'));
  assert.notOk(this.subject().get('isPhotoUploaded'));
});

test('isPhotoUploaded is false if avatarUrl is empty', function(assert) {
  Ember.run(() => this.subject().set('avatarUrl', ''));
  assert.notOk(this.subject().get('isPhotoUploaded'));
});

test('isPhotoUploaded is true if the user change its photo', function(assert) {
  Ember.run(() => this.subject().set('avatarUrl', 'toto.png'));
  assert.ok(this.subject().get('isPhotoUploaded'));
});

test('isFirstQuestionsAnswered is true if no interview_question', function(assert) {
  manualSetup(this.container);
  let questions = makeList('question', 5);
  Ember.run(() => this.subject().set('questions', questions));
  assert.ok(this.subject().get('isFirstQuestionsAnswered'));
});

test('isFirstQuestionsAnswered is false initially', function(assert) {
  manualSetup(this.container);
  let questions = makeList('question', 5, { step: 'first_interview' });
  Ember.run(() => this.subject().set('questions', questions));
  assert.notOk(this.subject().get('isFirstQuestionsAnswered'));
});

test('isFirstQuestionsAnswered is true if all the first_interview step', function(assert) {
  manualSetup(this.container);
  let questions = makeList('question', 5, { step: 'first_interview' });
  Ember.run(() => this.subject().set('questions', questions));

  Ember.run(() => questions.forEach(q => { 
    q.set('answer', '');
  }));

  assert.notOk(this.subject().get('isFirstQuestionsAnswered'));
});

test('isFirstQuestionsAnswered is true after 5 questions answered', function(assert) {
  manualSetup(this.container);
  let questions = makeList('question', 5, { step: 'first_interview' });
  Ember.run(() => this.subject().set('questions', questions));

  Ember.run(() => questions.forEach(q => { 
    q.set('answer', 'something');
  }));

  assert.ok(this.subject().get('isFirstQuestionsAnswered'));
});


test('isFirstInterviewAnswered is true if firstquestions and jobTitle and doAuthorize', function(assert) {
  manualSetup(this.container);
  assert.notOk(this.subject().get('isFirstInterviewAnswered'));

  let questions = makeList('question', 5, { step: 'first_interview' });
  Ember.run(() => this.subject().set('questions', questions));

  Ember.run(() =>this.subject().set('doAuthorize', true));
  assert.notOk(this.subject().get('isFirstInterviewAnswered'));

  Ember.run(() =>this.subject().set('jobTitle', 'toto'));
  assert.notOk(this.subject().get('isFirstInterviewAnswered'));

  Ember.run(() => questions.forEach(q => { 
    q.set('answer', 'something');
  }));

  assert.ok(this.subject().get('isFirstInterviewAnswered'));
});
