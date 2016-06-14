import { moduleForComponent, test } from 'ember-qunit';
import Ember from 'ember';

moduleForComponent('challenge-2', {
  unit: true,
});

test('it exists', function(assert) {
  let user = Ember.Object.create({ save(){}, books: { then(f){f([]);} } });
  let component = this.subject({user: user});
  assert.ok(!!component);
});
