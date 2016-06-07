import { join } from 'ember-quickstart/helpers/join';
import { module, test } from 'qunit';
import Ember from 'ember';

module('Unit | Helper | join');

test('it works', function(assert) {
  let array = ['toto', 'tata'].map( e => Ember.Object.create({name: e}) );
  let result = join([array, 'name']);
  assert.equal(result, 'toto, tata');
});
