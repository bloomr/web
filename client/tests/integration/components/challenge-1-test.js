import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';
import { clickTrigger, nativeMouseUp } from '../../helpers/ember-power-select';

import { make, makeList, manualSetup, mockFindAll } from 'ember-data-factory-guy';

const introSentence = "Nous avons défini ces tribus pour aider les jeunes à s'orienter.";
const choiceSentence = "Quelle(s) tribu(s) vous conviendrai(en)t ?";
const successSentence = 'Vous avez gagné';

moduleForComponent('challenge-1', 'Integration | Component | challenge 1', {
  integration: true,
  beforeEach() {
    manualSetup(this.container);
    let [tribe0, tribe1, tribe2] = makeList('tribe', 3);
    mockFindAll('tribe').returns({models:[tribe0, tribe1, tribe2]});
    let user2 = make('user', {tribes: [tribe2]});
    this.set('user', user2);
    //do not know how to do otherwise
    user2.save = () => {};
    let challenge = make('challenge', {name: 'the tribes'});
    this.set('challenges', Ember.A([challenge]));
    this.tribe2 = tribe2;
  },
});

test('a user can change its tribes', function(assert) {
  this.render(hbs`{{challenge-1 user=user challenges=challenges}}`);

  assert.ok(this.$().text().includes(introSentence));
  
  this.$('.tribeKO').click();
  assert.ok(this.$().text().includes(choiceSentence));

  clickTrigger();

  assert.equal($('.ember-power-select-option').length, 3);
  nativeMouseUp('.ember-power-select-option[data-option-index="0"]');

  this.$('.save').click();
  
  assert.equal(this.get('user.tribes.length'), 2);
  assert.ok(this.get('user.tribes').indexOf(this.tribe2) !== -1);
  assert.ok(this.$().text().includes(successSentence));

  assert.ok(this.$().text().includes('Bienvenue chez : tribe3, tribe1 !'));
});

test('a user accepts its default tribe', function(assert) {
  this.render(hbs`{{challenge-1 user=user challenges=challenges}}`);

  this.$('.tribeOK').click();
  assert.ok(this.$().text().includes(successSentence));
});

test('a user whith no tribe start with the choice screen', function(assert) {
  let self = this;
  Ember.run(function(){
    self.set('user.tribes', []);
    self.render(hbs`{{challenge-1 user=user challenges=challenges}}`);
    assert.ok(self.$().text().includes(choiceSentence));
  });
});

test('a user who has allready done the challenge start with the succeed screen', function(assert) {
  this.get('user.challenges').setObjects([make('challenge', {name: 'the tribes'})]);
  this.render(hbs`{{challenge-1 user=user challenges=challenges}}`);
  assert.ok(this.$().text().includes(successSentence));
});

test('a user who has allready done another challenge start with the intro screen', function(assert) {
  this.get('user.challenges').setObjects([make('challenge', {name: 'another'})]);
  this.render(hbs`{{challenge-1 user=user challenges=challenges}}`);
  assert.ok(this.$().text().includes(introSentence));
});
