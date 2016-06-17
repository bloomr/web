import Ember from 'ember';
import { moduleFor, test } from 'ember-qunit';
import { manualSetup, make } from 'ember-data-factory-guy';

moduleFor('component:challenge-layout', 'Unit | Component | challenge-layout', {
  unit: true,
  needs: ['model:user', 'model:challenge'],
  beforeEach() {
    manualSetup(this.container);
  }
});

test('it exists', function(assert) {
  let user = make('user');
  let model = { user: user };
  let controller = this.subject({model: model});
  assert.ok(controller);
});

test('display challenge-1', function(assert) {
  let user = make('user');
  let model = { user: user };
  let controller = this.subject({model: model});
  assert.equal(controller.get('currentChallenge'), 'challenge-1');
});

test('display challenge-2 if challenge1 is done', function(assert) {
  let self = this;
  let user = make('user', { challenges: [make('challenge', {name: 'the tribes'})]});
  let model = { user: user };
  let controller;
  Ember.run(() => { controller = self.subject({model: model}); });

  assert.equal(controller.get('currentChallenge'), 'challenge-2');
});
