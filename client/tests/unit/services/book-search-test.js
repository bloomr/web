import { moduleFor, test } from 'ember-qunit';
import Ember from 'ember';
import sinon from 'sinon';

moduleFor('service:book-search', 'Unit | Service | book search', {
  beforeEach(){
    this.promise = {};
    Ember.$.get = sinon.stub();
    Ember.$.get.returns(this.promise);
  }
});

test('it queries the book with a encodeUri and return the promise', function(assert) {
  let query = 'entreprise libérée';

  let result = this.subject().search(query);

  let expected = '/api/v1/books/search?keywords=' + encodeURIComponent(query); 
  assert.equal(Ember.$.get.args[0][0], expected);
  assert.equal(this.promise, result);
});


test('it queries the book in english if necessary', function(assert) {
  let query = 'originals';

  let result = this.subject().search(query, {inEnglish: true});

  let expected = '/api/v1/books/search?keywords=originals&inEnglish=true';
  assert.equal(Ember.$.get.args[0][0], expected);
  assert.equal(this.promise, result);
});
