import { moduleForComponent, test } from 'ember-qunit';
import Ember from 'ember';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('challenge-2', 'Integration | Component | challenge 2', {
  integration: true,
  beforeEach() {
    this.set('user', Ember.Object.create({ save(){}, books: { then(f){f([]);} } }));
  }
});

test('I can search a book and add it to my collections', function(assert) {
  this.render(hbs`{{challenge-2 user=user}}`);

  this.$('input').val('super book');
  
  let callback;
  Ember.$.get = () => { return { done(f) { callback = f; } }; }; 
  
  this.$('a.search').click();
  assert.ok(this.$().text().includes("on cherche dans l'internet"));

  Ember.run(function(){ callback([{title: 'titre: un super book'}]); });

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
  Ember.$.get = () => { return { done(f) { f([{title: 'titre: un super book'}]); } }; };
  this.$('a.search').click();
  this.$('.title').click();

  this.$('.oneAgain').click();

  this.$('input').val('tip top');
  Ember.$.get = () => { return { done(f) { f([{title: 'titre: tip top'}]); } }; };
  this.$('a.search').click();
  this.$('.title').click();

  assert.ok(this.$().text().includes('titre: un super book'));
  assert.ok(this.$().text().includes('titre: tip top'));
});
