import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('challenge-finish', 'Integration | Component | challenge finish', {
  integration: true
});

test('it renders', function(assert) {
  this.render(hbs`{{challenge-finish}}`);

  assert.notEqual(this.$().text().trim(), '');
});
