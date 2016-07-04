import { moduleForComponent, test } from 'ember-qunit';
import { make, manualSetup } from 'ember-data-factory-guy';
import Ember from 'ember';

moduleForComponent('challenge-interview', {
  unit: true,
  needs: ['model:user', 'model:question'],
  beforeEach() {
    manualSetup(this.container);
    this.user = make('user');
    this.component = this.subject({user: this.user});
  }
});

test('toggle doAuthorize', function(assert) {
  assert.equal(this.user.get('doAuthorize'), undefined);
  Ember.run(() => this.component.toggleDoAuthorize());
  assert.ok(this.user.get('doAuthorize'));
  Ember.run(() => this.component.toggleDoAuthorize());
  assert.notOk(this.user.get('doAuthorize'));
});
