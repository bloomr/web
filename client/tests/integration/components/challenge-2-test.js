import { moduleForComponent, test } from 'ember-qunit';
import Ember from 'ember';
import hbs from 'htmlbars-inline-precompile';
import { make, manualSetup } from 'ember-data-factory-guy';
import sinon from 'sinon';
import { initCustomAssert } from '../../assertions/custom';

moduleForComponent('challenge-2', 'Integration | Component | challenge 2', {
  integration: true,
  beforeEach() {
    manualSetup(this.container);
    this.set('user', make('user'));
    this.set('challenges', []);
    this.searchStub = sinon.stub(this.container.lookup('service:book-search'), 'search');
    initCustomAssert(this);
  }
});

test('I can search a book and add it to my collections', function(assert) {

  this.render(hbs`{{challenge-2 user=user challenges=challenges}}`);

  this.$('input').val('super book');
  
  let promise = $.Deferred();
  this.searchStub.returns(promise);
  this.$('a.search').click();
  assert.templateContains("on cherche dans l'internet");

  Ember.run(function(){ promise.resolve([{title: 'titre: un super book'}]); });

  assert.templateContains('titre: un super book');
  assert.notOk(this.$().text().includes("on cherche dans l'internet"));

  this.$('.title').click();
  assert.equal(this.$('input').length, 0);

  sinon.stub(this.container.lookup('service:store'), 'createRecord').returns({save: $.noop});

  this.$('a.done').click();
  assert.templateContains('Bien joué !');
});

test('I can search a book and another one', function(assert) {
  this.render(hbs`{{challenge-2 user=user}}`);

  this.$('input').val('super book');
  this.searchStub.returns({ then(callback) { callback([{title: 'titre: un super book'}]); }});
  this.$('a.search').click();
  this.$('.title').click();

  this.$('.oneAgain').click();
  this.$('input').val('tip top');

  this.searchStub.returns({ then(callback) { callback([{title: 'titre: tip top'}]); }});
  this.$('a.search').click();
  this.$('.title').click();

  assert.templateContains('titre: un super book');
  assert.templateContains('titre: tip top');
});
