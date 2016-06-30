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
  Ember.run(() => this.subject().set('avatarUrl', 'missing_thumb.png'));
  assert.notOk(this.subject().get('isPhotoUploaded'));
});

test('isPhotoUploaded is true if the user change its photo', function(assert) {
  Ember.run(() => this.subject().set('avatarUrl', 'toto.png'));
  assert.ok(this.subject().get('isPhotoUploaded'));
});

test('isFirstQuestionsAnswered is false initially', function(assert) {
  assert.notOk(this.subject().get('isFirstQuestionsAnswered'));
});

test('isFirstQuestionsAnswered is false after 5 questions answered but empty', function(assert) {
  manualSetup(this.container);
  let questions = makeList('question', 5);
  Ember.run(() => this.subject().set('questions', questions));

  Ember.run(() => questions.forEach(q => { 
    q.set('answer', '');
    q.set('hasDirtyAttributes', false);
  }));

  assert.notOk(this.subject().get('isFirstQuestionsAnswered'));
});

test('isFirstQuestionsAnswered is true after 5 questions answered', function(assert) {
  manualSetup(this.container);
  let questions = makeList('question', 5);
  Ember.run(() => this.subject().set('questions', questions));

  Ember.run(() => questions.forEach(q => { 
    q.set('answer', 'something');
    q.set('hasDirtyAttributes', false);
  }));

  assert.ok(this.subject().get('isFirstQuestionsAnswered'));
});
