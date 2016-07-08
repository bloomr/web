import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('keywords-select', 'Integration | Component | keywords select', {
  integration: true
});

test('it renders', function(assert) {
  this.render(hbs`{{keywords-select}}`);

  assert.equal(this.$().text().trim(), '');
});
