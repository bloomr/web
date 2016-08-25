import { moduleForComponent, test } from 'ember-qunit';
import { make, manualSetup } from 'ember-data-factory-guy';
import Ember from 'ember';
import sinon from 'sinon';

let Promise = Ember.RSVP.Promise; // jshint ignore:line

let stubAndReturnPromise = (obj, name, result) => {
  let promise = $.Deferred();
  promise.resolve(result);
  obj[name] = sinon.stub();
  obj[name].returns(promise);
  return [obj[name], promise];
};

moduleForComponent('challenge-mustread', {
  unit: true,
  needs: ['model:user', 'model:book', 'model:challenge'],
  beforeEach() {
    manualSetup(this.container);
    this.user = make('user');
    this.user.save = sinon.stub();
    this.register('service:book-search', Ember.Service.extend({}));
    [this.stub] = stubAndReturnPromise(this.container.lookup('service:book-search'), 'search', []);
    this.challenges = [make('challenge', { name: 'must read' })];
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

test('saveNewBooks saves ... new book', function(assert) {
  let component = this.subject({user: this.user, challenges: this.challenges});
  let createRecordStub = sinon.stub(this.container.lookup('service:store'), 'createRecord');
  let saveStub = sinon.stub();
  let result = {};
  saveStub.returns(result);
  createRecordStub.returns({save: saveStub});

  return component.saveNewBooks([{title: 'title'}])
    .then(records => {
      assert.ok(createRecordStub.called);
      assert.ok(saveStub.called);
      assert.equal(records[0], result);
    });
});

test('saveNewBooks does not save ... old book', function(assert) {
  let component = this.subject({user: this.user, challenges: this.challenges});
  let book = make('book');
  let createRecordStub = sinon.stub(this.container.lookup('service:store'), 'createRecord');

  return component.saveNewBooks([book])
    .then(records => {
      assert.notOk(createRecordStub.called);
      assert.equal(records[0], book);
    });
});

test('saveBookAndUser', function(assert) {

  let challengeService = { updateMustReadChallenge: sinon.spy(u => Promise.resolve(u)) };
  let component = this.subject({user: this.user, challenges: this.challenges, challengeService});
  component.selectedBooks = [{title: 'title'}];

  let book = make('book');
  let records = Promise.resolve([book]);
  let saveNewBooksStub = sinon.stub(component, 'saveNewBooks');
  saveNewBooksStub.returns(records);

  return component.saveBookAndUser()
    .then(u => {
      assert.equal(u.get('books.length'), 1);
      assert.ok(challengeService.updateMustReadChallenge.calledWith(u));
      assert.ok(u.save.called);
      assert.ok(component.saveNewBooks.calledWith(component.selectedBooks));
    });

});
