import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { manualSetup, make } from 'ember-data-factory-guy';
import sinon from 'sinon';
import Ember from 'ember';

moduleForComponent('image-upload', 'Integration | Component | image upload', {
  integration: true,
  beforeEach() {
    manualSetup(this.container);
    this.user = make('user', { avatarUrl: 'toto.png' });
    sinon.spy($.fn, 'fileupload');
    this.render(hbs`{{image-upload user=user}}`);
    this.fileuploadArgs = $.fn.fileupload.getCall(0).args[0];
    this.componentStyle = () => this.$('.image-upload').attr('style');
  },
  afterEach() {
    $.fn.fileupload.restore();
  }
});

test('it renders the user avatar', function(assert) {
  assert.equal(this.componentStyle(), "background-image: url('toto.png');");
});

test('it renders the spinner when its loading', function(assert) {
  Ember.run(() => this.fileuploadArgs.start());
  assert.equal(this.componentStyle(), "background-image: url('assets/images/loader.gif');");
});

test('it renders the new user avatar when loaded', function(assert) {
  Ember.run(() => this.fileuploadArgs.done({}, { result: { avatarUrl: 'newToto.png'} }));
  assert.ok(this.componentStyle().indexOf("background-image: url('newToto.png") === 0);
});
