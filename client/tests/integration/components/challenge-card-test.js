import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('challenge-card', 'Integration | Component | challenge card', {
  integration: true
});

test('it renders', function(assert) {
  this.set('challenges', []);
  this.render(hbs`{{challenge-card challenges=challenges}}`);

  assert.notEqual(this.$().text().trim(), '');
});
