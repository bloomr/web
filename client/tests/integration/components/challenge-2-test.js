import { moduleForComponent, test } from 'ember-qunit';
import Ember from 'ember';
import hbs from 'htmlbars-inline-precompile';
import { make } from 'ember-data-factory-guy';

moduleForComponent('challenge-2', 'Integration | Component | challenge 2', {
  integration: true,
  beforeEach() {
    this.set('user', make('user'));
    this.set('challenges', []);
    let promiseWrapper = { promise: $.Deferred() };
    this.register('service:book-search', Ember.Service.extend({ search() { return promiseWrapper.promise; } }));
    this.promiseWrapper = promiseWrapper;
  }
});

test('I can search a book and add it to my collections', function(assert) {
  this.render(hbs`{{challenge-2 user=user challenges=challenges}}`);

  this.$('input').val('super book');
  
  this.$('a.search').click();
  assert.ok(this.$().text().includes("on cherche dans l'internet"));

  let self = this;
  Ember.run(function(){ self.promiseWrapper.promise.resolve([{title: 'titre: un super book'}]); });

  assert.ok(this.$().text().includes('titre: un super book'));
  assert.notOk(this.$().text().includes("on cherche dans l'internet"));

  this.$('.title').click();
  assert.equal(this.$('input').length, 0);

  let store = this.container.lookup('service:store');
  store.createRecord = () => { return { save() {} }; };

  this.$('a.done').click();
  assert.ok(this.$().text().includes('Bien joué !'));
});

test('I can search a book and another one', function(assert) {
  this.render(hbs`{{challenge-2 user=user}}`);

  this.$('input').val('super book');
  let self = this;
  this.$('a.search').click();
  Ember.run(function(){ self.promiseWrapper.promise.resolve([{title: 'titre: un super book'}]); });
  this.$('.title').click();

  this.$('.oneAgain').click();

  this.promiseWrapper.promise = $.Deferred();
  this.$('input').val('tip top');
  this.$('a.search').click();
  Ember.run(function(){ self.promiseWrapper.promise.resolve([{title: 'titre: tip top'}]); });
  this.$('.title').click();

  assert.ok(this.$().text().includes('titre: un super book'));
  assert.ok(this.$().text().includes('titre: tip top'));
});
