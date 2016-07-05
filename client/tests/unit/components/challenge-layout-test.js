import { moduleFor, test } from 'ember-qunit';
import { manualSetup, make } from 'ember-data-factory-guy';
import sinon from 'sinon';
import Ember from 'ember';

moduleFor('component:challenge-layout', 'Unit | Component | challenge-layout', {
  unit: true,
  needs: ['model:user', 'model:challenge'],
  beforeEach() {
    manualSetup(this.container);
    this.user = make('user', { challenges: [] });
    this.challenge1 = make('challenge');
    this.challenge1.set('position', 1);
    this.challenge1.set('widget', 'widget1');
    this.challenge2 = make('challenge');
    this.challenge2.set('position', 2);
    this.challenge3 = make('challenge');
    this.challenge3.set('position', 3);
    this.component = this.subject({
      user: this.user, 
      challenges: [this.challenge2, this.challenge3, this.challenge1]
    });
  }
});

test('it exists', function(assert) {
  assert.ok(this.component);
});

test('nextChallenge', function(assert) {
  assert.equal(this.component.nextChallenge(), this.challenge1);
  Ember.run(() => this.user.get('challenges').addObject(this.challenge1));
  assert.equal(this.component.nextChallenge(), this.challenge2);
});

test('updateCurrentWidget with no name given should set nextChallenge widget', function(assert) {
  sinon.stub(this.component, 'nextChallenge').returns(this.challenge1);
  this.component.updateCurrentWidget();
  assert.equal(this.component.get('currentChallenge'), 'widget1');
});

test('updateCurrentWidget should set name widhet', function(assert) {
  this.component.set('name', 'toto');
  this.component.updateCurrentWidget();
  assert.equal(this.component.get('currentChallenge'), 'challenge-toto');
});
