import { moduleForModel, test } from 'ember-qunit';
import Ember from 'ember';
import { make, makeList, manualSetup } from 'ember-data-factory-guy';

moduleForModel('user', 'Unit | Model | user', {
  // Specify the other units that are required for this test.
  needs: ['model:tribe', 'model:question', 'model:challenge',
    'model:book', 'model:keyword', 'model:strength'],
  beforeEach() {
    manualSetup(this.container);
  }
});

test('isPhotoUploaded is false initially', function(assert) {
  Ember.run(() => this.subject().set('avatarUrl', 'missing.png-0123'));
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

test('isFirstQuestionsAnswered is true if no mandatory questions', function(assert) {
  manualSetup(this.container);
  let questions = makeList('question', 5, { step: 'first_interview', mandatory: false });
  Ember.run(() => this.subject().set('questions', questions));
  assert.ok(this.subject().get('isFirstQuestionsAnswered'));
});

test('isFirstQuestionsAnswered is false initially', function(assert) {
  manualSetup(this.container);
  let questions = makeList('question', 5, { step: 'first_interview', mandatory: true });
  Ember.run(() => this.subject().set('questions', questions));
  assert.notOk(this.subject().get('isFirstQuestionsAnswered'));
});

test('isFirstQuestionsAnswered is false if all the first_interview step are blank', function(assert) {
  manualSetup(this.container);
  let questions = makeList('question', 5, { step: 'first_interview', mandatory: true });
  Ember.run(() => this.subject().set('questions', questions));

  Ember.run(() => questions.forEach(q => { 
    q.set('answer', '');
  }));

  assert.notOk(this.subject().get('isFirstQuestionsAnswered'));
});

test('isFirstQuestionsAnswered is true after all mandatory questions are answerd', function(assert) {
  manualSetup(this.container);
  let mandatory_qs = makeList('question', 2, { step: 'first_interview', mandatory: true });
  let qs = makeList('question', 2, { step: 'first_interview', mandatory: false });
  Ember.run(() => this.subject().set('questions', mandatory_qs.concat(qs)));

  Ember.run(() => mandatory_qs.forEach(q => {
    q.set('answer', 'something');
  }));

  assert.ok(this.subject().get('isFirstQuestionsAnswered'));
});


test('isFirstInterviewAnswered is true if firstquestions and jobTitle and doAuthorize', function(assert) {
  manualSetup(this.container);
  assert.notOk(this.subject().get('isFirstInterviewAnswered'));

  let questions = makeList('question', 5, { step: 'first_interview', mandatory: true });
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

test('add challenge', function(assert) {
  let challenge = make('challenge');
  let model = this.subject();

  return model.addChallenge(challenge)
    .then(user => assert.equal(user.get('challenges.length'), 1));
});

test('remove challenge', function(assert) {
  let challenge = make('challenge');
  let model = this.subject();

  return model.get('challenges')
    .then(c => c.addObject(challenge))
    .then(() => model.removeChallenge(challenge))
    .then(u => assert.equal(u.get('challenges.length'), 0));
});

test('set tribes', function(assert) {
  let [t0, t1] = makeList('tribe', 2);
  let model = this.subject();

  return model.get('tribes')
    .then(tribes => tribes.addObjects([t0]))
    .then(() => model.setTribes([t1]))
    .then(user => { 
      assert.equal(user.get('tribes.length'), 1); 
      assert.equal(user.get('tribes').objectAt(0), t1); 
    });
});

test('set strengths', function(assert) {
  let [s0, s1] = makeList('strength', 2);
  let model = this.subject();

  return model.get('strengths')
    .then(tribes => tribes.addObjects([s0]))
    .then(() => model.setStrengths([s1]))
    .then(user => { 
      assert.equal(user.get('strengths.length'), 1); 
      assert.equal(user.get('strengths').objectAt(0), s1); 
    });
});

test('set books', function(assert) {
  let [b0, b1] = makeList('book', 2);
  let model = this.subject();

  return model.get('books')
    .then(books => books.addObjects([b0]))
    .then(() => model.setBooks([b1]))
    .then(user => { 
      assert.equal(user.get('books.length'), 1); 
      assert.equal(user.get('books').objectAt(0), b1); 
    });
});

test('questions_by_step', function(assert) {
  let [q0, q1] = makeList('question', {step: 'first_interview'}, {step: 'other'});

  let model = this.subject();

  return model.get('questions')
    .then(questions => questions.addObjects([q0, q1]))
    .then(() => model.questions_by_step('first_interview'))
    .then(questions => { 
      assert.equal(questions.get('length'), 1); 
      assert.equal(questions[0], q0); 
    });
});
