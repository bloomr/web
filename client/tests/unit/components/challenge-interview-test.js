import { moduleForComponent, test } from 'ember-qunit';
import { make, makeList, manualSetup } from 'ember-data-factory-guy';
import Ember from 'ember';
import sinon from 'sinon';

moduleForComponent('challenge-interview', {
  unit: true,
  needs: ['model:user', 'model:question'],
  beforeEach() {
    manualSetup(this.container);
    let questions = makeList('question', 3);
    questions.forEach(q => sinon.stub(q, 'save'));

    this.user = make('user', { questions: questions });
    sinon.stub(this.user, 'save');
    this.component = this.subject({user: this.user});
  }
});

test('toggle doAuthorize', function(assert) {
  assert.equal(this.user.get('doAuthorize'), undefined);
  Ember.run(() => this.component.toggleDoAuthorize());
  assert.ok(this.user.get('doAuthorize'));
  Ember.run(() => this.component.toggleDoAuthorize());
  assert.notOk(this.user.get('doAuthorize'));
});


test('go to step 3 saves the user and its questions', function(assert) {
  this.component.actions.go_step3.apply(this.component);
  assert.ok(this.user.save.called);
  assert.ok(this.user.get('questions').every(q => q.save.called));
});
