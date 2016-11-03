import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { clickTrigger, nativeMouseUp } from '../../helpers/ember-power-select';

import { make, makeList, manualSetup, mockFindAll } from 'ember-data-factory-guy';
import sinon from 'sinon';

const introSentence = 'Trouvez vos forces';
const formSentence = 'Partagez-nous vos résultats !';
const successSentence = 'Bien reçu !';

moduleForComponent('challenge-strengths', 'Integration | Component | challenge strengths', {
  integration: true,
  beforeEach() {
    manualSetup(this.container);
    let [strength0, strength1, strength2] = makeList('strength', 3);
    mockFindAll('strength').returns({models:[strength0, strength1, strength2]});
    let user = make('user', {strengths: [strength2]});
    user.save = sinon.stub();
    this.set('user', user);

    this.challenge = make('challenge', {name: 'strengths'});
    mockFindAll('challenge').returns({models:[this.challenge]});
    this.strength2 = strength2;
  },
});

test('a user can add its strengths', function(assert) {
  this.render(hbs`{{challenge-strengths user=user}}`);

  assert.ok(this.$().text().includes(introSentence));
  
  this.$('.go-to-form').click();
  assert.ok(this.$().text().includes(formSentence));

  clickTrigger();

  assert.equal($('.ember-power-select-option').length, 3);
  nativeMouseUp('.ember-power-select-option[data-option-index="0"]');

  this.$('.save').click();
  assert.ok(this.get('user').save.called);

  assert.equal(this.get('user.strengths.length'), 2);
  assert.ok(this.get('user.strengths').indexOf(this.strength2) !== -1);
  assert.ok(this.get('user.challenges').indexOf(this.challenge) !== -1);
  assert.ok(this.$().text().includes(successSentence));
});
