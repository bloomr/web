import { moduleForComponent, test } from 'ember-qunit';
import { make, makeList, mockFindAll, manualSetup } from 'ember-data-factory-guy';
import Ember from 'ember';
import sinon from 'sinon';

moduleForComponent('challenge-1', {
  unit: true,
  needs: ['model:user', 'model:challenge', 'model:tribe'],
  beforeEach() {
    manualSetup(this.container);
    this.user = make('user', { tribes: Ember.A([]) });
    this.user.save = sinon.stub();
    this.challenges = [make('challenge', { name: 'the tribes' })];
    this.tribes = makeList('tribe', 3);
    mockFindAll('tribe').returns({models: this.tribes });
    Ember.run(() => { 
      this.component = this.subject({user: this.user, challenges: this.challenges});
    });
  }
});

test('updateUser saves a added tribe', function(assert) {
  this.component.selectedTribes = [this.tribes[0]];

  Ember.run(() => { this.component.updateUser(); });

  assert.equal(this.user.get('tribes.length'), 1);
  assert.ok(this.user.save.called);
});

test('updateUser add tribe challenge to the user', function(assert) {
  Ember.run(() => { this.component.updateUser(); });

  let userChallenges = this.user.get('challenges');
  assert.equal(userChallenges.get('length'), 1);
  assert.equal(userChallenges.objectAt(0), this.challenges[0]);
});

test('updateUser removes deleted tribes', function(assert) {
  this.user.tribes = this.tribes;
  this.component.selectedTribes = [];

  Ember.run(() => { this.component.updateUser(); });

  assert.equal(this.user.get('tribes.length'), 0);
});
