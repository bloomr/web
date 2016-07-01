import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { initCustomAssert } from '../../assertions/custom';
import { make, manualSetup } from 'ember-data-factory-guy';

moduleForComponent('profile-introduction', 'Integration | Component | profile introduction', {
  integration: true,
  beforeEach(){
    initCustomAssert(this);
    manualSetup(this.container);
    this.interviewChallenge = make('challenge', { name: 'interview' });
    this.set('user', make('user'));
  }
});

test('it is hidden if the user has made the interview challenge', function(assert) {
  this.set('user.challenges', [this.interviewChallenge]);
  this.render(hbs`{{profile-introduction user=user}}`);
  assert.ok(this.$('div').hasClass('hidden'));
});

test('it is not hidden otherwise', function(assert) {
  this.render(hbs`{{profile-introduction user=user}}`);
  assert.notOk(this.$('div').hasClass('hidden'));
});
