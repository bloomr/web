import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';
import { clickTrigger, nativeMouseUp } from '../../helpers/ember-power-select';

const introSentence = "Nous avons défini ces tribus pour aider les jeunes à s'orienter.";
const choiceSentence = "Quelle(s) tribu(s) vous conviendrai(en)t ?";
const successSentence = 'Vous avez gagné';

moduleForComponent('challenge-1', 'Integration | Component | challenge 1', {
  integration: true,
  beforeEach() {
    let [tribe0, tribe1, tribe2] = ['tribe0', 'tribe1', 'tribe2'].map( (e, i) => Ember.Object.create({ id: i, name: e }));
    let user = Ember.Object.create({ tribes: [tribe2], challenges: [], save: function(){} });
    this.set('model', { tribes: [tribe0, tribe1, tribe2], user: user });
    this.set('tribe0', tribe0);
    this.tribe2 = tribe2;
  }
});

test('a user can change its tribes', function(assert) {
  this.render(hbs`{{challenge-1 model=model}}`);

  assert.ok(this.$().text().includes(introSentence));
  
  this.$('.tribeKO').click();
  assert.ok(this.$().text().includes(choiceSentence));

  clickTrigger();

  assert.equal($('.ember-power-select-option').length, 3);
  nativeMouseUp('.ember-power-select-option[data-option-index="0"]');

  this.$('.save').click();
  assert.equal(this.get('model.user.tribes').length, 2);
  assert.ok(this.get('model.user.tribes').indexOf(this.tribe2) !== -1);
  assert.ok(this.$().text().includes(successSentence));
  assert.ok(this.$().text().includes('Bienvenue chez : tribe2, tribe0 !'));
});

test('a user accepts its default tribe', function(assert) {
  this.render(hbs`{{challenge-1 model=model}}`);

  this.$('.tribeOK').click();
  assert.ok(this.$().text().includes(successSentence));
});

test('a user whith no tribe start with the choice screen', function(assert) {
  this.get('model').user.set('tribes', []);
  this.render(hbs`{{challenge-1 model=model}}`);

  assert.ok(this.$().text().includes(choiceSentence));
});

test('a user who has allready done the challenge start with the succeed screen', function(assert) {
  this.get('model').user.set('challenges', [Ember.Object.create({ name: 'the tribes' })]);
  this.render(hbs`{{challenge-1 model=model}}`);
  assert.ok(this.$().text().includes(successSentence));
});

test('a user who has allready done another challenge start with the intro screen', function(assert) {
  this.get('model').user.set('challenges', [Ember.Object.create({ name: 'another' })]);
  this.render(hbs`{{challenge-1 model=model}}`);
  assert.ok(this.$().text().includes(introSentence));
});
