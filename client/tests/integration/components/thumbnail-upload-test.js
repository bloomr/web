import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { manualSetup, make } from 'ember-data-factory-guy';
import sinon from 'sinon';
import Ember from 'ember';

moduleForComponent('thumbnail-upload', 'Integration | Component | thumbnail-upload', {
  integration: true,
  beforeEach() {
    manualSetup(this.container);
    this.user = make('user', { avatarUrl: 'toto.png' });
    sinon.spy(Ember.$.fn, 'fileupload');
    this.render(hbs`{{thumbnail-upload user=user}}`);
    this.fileuploadArgs = Ember.$.fn.fileupload.getCall(0).args[0];
    this.componentStyle = () => this.$('.thumbnail-upload').attr('style');
  },
  afterEach() {
    Ember.$.fn.fileupload.restore();
  }
});

test('it renders the user avatar', function(assert) {
  assert.equal(this.componentStyle(), "background-image: url('toto.png');");
});

test('it renders the spinner when user avatar is empty string', function(assert) {
  Ember.run(() => this.fileuploadArgs.start());
  assert.equal(this.componentStyle(), "background-image: url('/assets/images/loader.gif');");
});

test('it renders the spinner when its loading', function(assert) {
  Ember.run(() => this.set('user.avatarUrl', ''));
  assert.equal(this.componentStyle(), "background-image: url('/assets/images/loader.gif');");
});

test('it renders the new user avatar when loaded', function(assert) {
  Ember.run(() => this.fileuploadArgs.done({}, { result: { avatarUrl: 'newToto.png'} }));
  assert.equal(this.componentStyle(), "background-image: url('newToto.png');");
  assert.equal(this.user.get('avatarUrl'), 'newToto.png');
});
