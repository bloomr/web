import { moduleForComponent, test } from 'ember-qunit';
// import { make, makeList, manualSetup } from 'ember-data-factory-guy';
import Ember from 'ember';

moduleForComponent('keywords-select', {
  unit: true,
  needs: [],
  beforeEach() {
  }
});

test('search actions', function(assert) {
  this.component = this.subject();
  let keyword = Ember.Object.create({tag: 'édu'});
  this.component.set('options', [keyword]);

  let result = this.component.actions.search.apply(this.component, ['eDU']);

  assert.equal(result[0], keyword);
});

test('create keyword', function(assert) {
  this.component = this.subject();
  this.component.set('options', []);
  this.component.set('selected', []);

  this.component.actions.createKeyword.apply(this.component, ['toto']);

  assert.equal(this.component.get('options')[0].get('tag'), 'Toto');
  assert.equal(this.component.get('selected')[0].get('tag'), 'Toto');
});
