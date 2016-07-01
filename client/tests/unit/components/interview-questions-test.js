import { moduleForComponent, test } from 'ember-qunit';
import { make, makeList, manualSetup } from 'ember-data-factory-guy';
import Ember from 'ember';

moduleForComponent('interview-questions', {
  unit: true,
  needs: ['model:user', 'model:question'],
  beforeEach() {
    manualSetup(this.container);
    this.questions = makeList('question', 2);
    this.user = make('user', { questions: this.questions });
    this.component = this.subject({user: this.user});
  }
});

test('disabled is true at the beginning', function(assert) {
  assert.ok(this.component.get('disabled'));
});

test('disabled is false if the user jobTitle hasChanged', function(assert) {
  Ember.run(() => this.user.set('jobTitle', 'toto'));
  assert.notOk(this.component.get('disabled'));
});

test('disabled is false if one of the questions has changed', function(assert) {
  Ember.run(() => this.user.get('questions').objectAt(0).set('answer', 'great'));
  assert.notOk(this.component.get('disabled'));
});
