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

test('display challenge-interview', function(assert) {
  let user = make('user');
  let model = { user: user };
  let controller = this.subject({model: model});
  assert.equal(controller.get('currentChallenge'), 'challenge-interview');
});
