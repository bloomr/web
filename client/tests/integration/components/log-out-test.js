import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';
import sinon from 'sinon';

moduleForComponent('log-out', 'Integration | Component | log out', {
  integration: true,
  beforeEach() { sinon.spy(Ember.$, 'ajax'); },
  afterEach() { Ember.$.ajax.restore(); }
});

test('it renders', function(assert) {
  this.render(hbs`{{log-out}}`);
  assert.equal(this.$().text().trim(), 'Déconnexion');
});

test('when we click it logs out', function(assert) {
  this.render(hbs`{{log-out}}`);
  this.$('a').click();
  assert.ok(Ember.$.ajax.called);

  let ajaxArgs = Ember.$.ajax.getCall(0).args[0];

  assert.equal(ajaxArgs.url, '/users/sign_out');
  assert.equal(ajaxArgs.type, 'DELETE');
});
