import { moduleForComponent, test } from 'ember-qunit';
import { make, manualSetup } from 'ember-data-factory-guy';
import Ember from 'ember';
import sinon from 'sinon';

moduleForComponent('challenge-2', {
  unit: true,
  needs: ['model:user', 'model:book'],
  beforeEach() {
    manualSetup(this.container);
    this.user = make('user');
    let promise = $.Deferred();
    promise.resolve([]);
    this.stub = sinon.stub();
    this.stub.returns(promise);
    this.register('service:book-search', Ember.Service.extend({ search: this.stub }));
  }
});

test('it looks for a book in french', function(assert) {
  let component = this.subject({user: this.user});
  component.send('search');
  assert.notOk(this.stub.args[0][1].inEnglish);
});

test('it looks for a book in english when asks', function(assert) {
  let component = this.subject({user: this.user});
  component.inEnglish = true;
  component.send('search');
  assert.ok(this.stub.args[0][1].inEnglish);
});
