import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('image-upload', 'Integration | Component | image upload', {
  integration: true
});

test('it renders', function(assert) {
  this.render(hbs`{{image-upload}}`);

  assert.equal(this.$().text().trim(), '');
});
