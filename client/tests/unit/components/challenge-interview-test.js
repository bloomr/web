import { moduleForComponent, test } from 'ember-qunit';
import { make, makeList, manualSetup, mockFindAll } from 'ember-data-factory-guy';
import Ember from 'ember';
import sinon from 'sinon';

moduleForComponent('challenge-interview', {
  unit: true,
  needs: ['model:user', 'model:question', 'model:challenge', 'model:keyword'],
  beforeEach() {
    manualSetup(this.container);
    mockFindAll('keyword');

    let interviewQ = { step: 'first_interview' };
    let questions = makeList('question', interviewQ, interviewQ, interviewQ);
    questions.forEach(q => sinon.stub(q, 'save'));

    this.user = make('user', { questions: questions });
    sinon.stub(this.user, 'save');

    this.challengeInterview = make('challenge', { name: 'interview' });

    this.component = this.subject({user: this.user, challenges: [this.challengeInterview]});
  }
});

test('toggle doAuthorize', function(assert) {
  assert.equal(this.user.get('doAuthorize'), undefined);
  Ember.run(() => this.component.toggleDoAuthorize());
  assert.ok(this.user.get('doAuthorize'));
  Ember.run(() => this.component.toggleDoAuthorize());
  assert.notOk(this.user.get('doAuthorize'));
});

test('populates first interview questions', function(assert) {
  assert.equal(this.component.get('firstInterviewQuestions.length'), 3);
});

test('saveNewKeyword', function(assert) {
  let saveStub = sinon.stub();
  let store = this.component.get('store');
  let createRecordStub = sinon.stub(store, 'createRecord');
  createRecordStub.returns({ save: saveStub });

  this.component.saveNewKeywords([Ember.Object.create({tag: 'toto'})]);

  assert.ok(createRecordStub.calledWith('keyword', {tag: 'toto'}));
  assert.ok(saveStub.called);
});

test('saveKeywordsAndUser saves a lot', function(assert) {
  let keyword = make('keyword');
  let saveNewKeywordsStub = sinon.stub(this.component, 'saveNewKeywords');
  saveNewKeywordsStub.returns([keyword]);

  let selectedKeywords = [];
  this.component.set('selectedKeywords', selectedKeywords);
  Ember.run(() => this.component.saveKeywordsAndUser());

  assert.ok(saveNewKeywordsStub.calledWith(selectedKeywords));
  assert.ok(this.user.save.called);
  assert.ok(this.user.get('questions').every(q => q.save.called));
  assert.equal(this.user.get('keywords').objectAt(0), keyword);
});

test('saveChallengeAndUser', function(assert){
  let addChallenge = sinon.spy((user) => Promise.resolve(user));

  this.component.set('challengeService', { addChallenge });

  return this.component.saveChallengeAndUser()
    .then(() => {
      assert.ok(addChallenge.calledWith(this.user, 'interview'));
      assert.ok(this.user.save.called);
    });
});

test('go_step3 saveTheChallenge', function(assert){
  let saveChallengeAndUserStub = sinon.stub(this.component, 'saveChallengeAndUser');
  Ember.run(() => this.component.actions.go_step3.apply(this.component));
  assert.ok(saveChallengeAndUserStub.called);
});

test('step2Enable', function(assert){
  this.component.set('selectedKeywords', []);
  this.user.set('isFirstInterviewAnswered', false);

  assert.notOk(this.component.get('step2Enable'));

  this.component.set('selectedKeywords', [1, 2, 3]);
  this.user.set('isFirstInterviewAnswered', false);
  assert.notOk(this.component.get('step2Enable'));

  this.component.set('selectedKeywords', [1, 2]);
  this.user.set('isFirstInterviewAnswered', true);
  assert.notOk(this.component.get('step2Enable'));

  this.component.set('selectedKeywords', [1, 2, 3]);
  this.user.set('isFirstInterviewAnswered', true);
  assert.ok(this.component.get('step2Enable'));
});
