import { moduleFor, test } from 'ember-qunit';
import sinon from 'sinon';
import { make, manualSetup } from 'ember-data-factory-guy';

moduleFor('route:index', 'Unit | Route | index', {
  needs: ['model:user', 'model:challenge'],
});

test('should route to challenge if user has not made interview challenge', function(assert) {
  manualSetup(this.container);
  let route = this.subject();
  let model = { user: make('user') };
  sinon.stub(route, 'transitionTo');

  route.afterModel(model);

  assert.ok(route.transitionTo.calledWith('challenges'));
});

test('should route to whatsnew otherwise', function(assert) {
  manualSetup(this.container);
  let route = this.subject();
  let model = { user: make('user', { challenges: [ make('challenge', { name: 'interview' }) ]}) };
  sinon.stub(route, 'transitionTo');

  route.afterModel(model);

  assert.ok(route.transitionTo.calledWith('whatsnew'));
});
