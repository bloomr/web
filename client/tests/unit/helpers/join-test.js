import { join } from 'ember-quickstart/helpers/join';
import { module, test } from 'qunit';
import Ember from 'ember';

module('Unit | Helper | join');

test('it works with 0 element', function(assert) {
  let result = join([[], 'name']);
  assert.equal(result, '');
});

test('it works with 1', function(assert) {
  let array = ['toto'].map( e => Ember.Object.create({name: e}) );
  let result = join([array, 'name']);
  assert.equal(result, 'toto');
});

test('it works with 2 elements', function(assert) {
  let array = ['toto', 'tata'].map( e => Ember.Object.create({name: e}) );
  let result = join([array, 'name']);
  assert.equal(result, 'toto et tata');
});

test('it works with 3 elements', function(assert) {
  let array = ['toto', 'tata', 'titi'].map( e => Ember.Object.create({name: e}) );
  let result = join([array, 'name']);
  assert.equal(result, 'toto, tata et titi');
});
