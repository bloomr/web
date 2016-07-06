import Ember from 'ember';
import { moduleFor, test } from 'ember-qunit';
import sinon from 'sinon';

moduleFor('route:application', 'Unit | Route | application', {
  needs: ['model:user', 'model:challenge'],
});

test('should call analytics on every page', function(assert) {
  window.ga = sinon.stub();
  let route = this.subject();
  route.router.get = sinon.stub();
  route.router.get.returns('myUrl');

  Ember.run(() => route.actions.didTransition.apply(route));

  assert.ok(window.ga.calledWith('send', 'pageview', {page: 'myUrl', title: 'myUrl'}));
});
