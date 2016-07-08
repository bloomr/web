import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { manualSetup, make, mockFindAll } from 'ember-data-factory-guy';
import sinon from 'sinon';
import Ember from 'ember';

moduleForComponent('challenge-interview', 'Integration | Component | challenge interview', {
  integration: true,
  beforeEach() {
    manualSetup(this.container);
    mockFindAll('keyword');
    this.user = make('user');
    sinon.spy($.fn, 'fileupload');
    this.render(hbs`{{challenge-interview user=user}}`);
    this.fileuploadArgs = $.fn.fileupload.getCall(0).args[0];
  },
  afterEach() {
    $.fn.fileupload.restore();
  }
});

test('the user avatar is set to empty string when loading', function(assert) {
  Ember.run(() => this.fileuploadArgs.start());
  assert.equal(this.user.get('avatarUrl'), '');
});

test('the user avatar is properly set after load', function(assert) {
  Ember.run(() => this.fileuploadArgs.done({}, { result: { avatarUrl: 'newToto.png'} }));
  assert.equal(this.user.get('avatarUrl'), 'newToto.png');
});
