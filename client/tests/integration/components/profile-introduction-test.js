import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { initCustomAssert } from '../../assertions/custom';
import { make, manualSetup } from 'ember-data-factory-guy';

moduleForComponent('profile-introduction', 'Integration | Component | profile introduction', {
  integration: true,
  beforeEach(){
    initCustomAssert(this);
    manualSetup(this.container);
    this.set('user', make('user'));
  }
});

test('it renders', function(assert) {
  this.render(hbs`{{profile-introduction user=user}}`);
  assert.templateContains('Bienvenue');
});
