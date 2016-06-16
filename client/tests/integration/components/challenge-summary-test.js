import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('challenge-summary', 'Integration | Component | challenge summary', {
  integration: true
});

test('it renders', function(assert) {
  this.set('challenges', []);
  this.set('user', { challenges: [] });
  this.set('toto', () => {});
  this.render(hbs`{{challenge-summary challenges=challenges user=user setCurrentChallenge=toto}}`);

  assert.notEqual(this.$().text().trim(), '');
});
