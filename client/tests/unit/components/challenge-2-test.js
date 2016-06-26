import { moduleForComponent, test } from 'ember-qunit';
import { make, manualSetup } from 'ember-data-factory-guy';
import Ember from 'ember';
import sinon from 'sinon';

let stubAndReturnPromise = (obj, name, result) => {
  let promise = $.Deferred();
  promise.resolve(result);
  obj[name] = sinon.stub();
  obj[name].returns(promise);
  return [obj[name], promise];
};

moduleForComponent('challenge-2', {
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

  let records = component.saveNewBooks([{title: 'title'}]);

  assert.ok(createRecordStub.called);
  assert.ok(saveStub.called);
  assert.equal(records[0], result);
});

test('saveNewBooks does not save ... old book', function(assert) {
  let component = this.subject({user: this.user, challenges: this.challenges});
  let book = make('book');
  let createRecordStub = sinon.stub(this.container.lookup('service:store'), 'createRecord');

  let records = component.saveNewBooks([book]);

  assert.notOk(createRecordStub.called);
  assert.equal(records[0], book);
});

test('addOrRemoveMustReadChallenge removes challenge if not books left', function(assert) {
  let mustReadChallenge = make('challenge', { name: 'must read' });
  let component = this.subject({user: this.user, challenges: [mustReadChallenge]});
  let userChallenges = [mustReadChallenge];
  component.addOrRemoveMustReadChallenge([], userChallenges);

  assert.equal(userChallenges.length, 0);
});

test('addOrRemoveMustReadChallenge add challenge if at least a book', function(assert) {
  let mustReadChallenge = make('challenge', { name: 'must read' });
  let component = this.subject({user: this.user, challenges: [mustReadChallenge]});
  let userChallenges = [];
  component.addOrRemoveMustReadChallenge(make('book'), userChallenges);

  assert.equal(userChallenges.length, 1);
  assert.equal(userChallenges[0], mustReadChallenge);
});

test('saveBookAndUser', function(assert) {
  let component = this.subject({user: this.user, challenges: this.challenges});
  component.selectedBooks = [{title: 'title'}];

  let book = make('book');
  let bookPromise = $.Deferred();
  bookPromise.resolve(book);
  let saveNewBooksStub = sinon.stub(component, 'saveNewBooks');
  saveNewBooksStub.returns([bookPromise]);

  sinon.stub(component, 'addOrRemoveMustReadChallenge');

  Ember.run(() => { component.saveBookAndUser(); });

  assert.equal(this.user.get('books.length'), 1);
  assert.ok(this.user.save.called);
  assert.ok(component.saveNewBooks.calledWith(component.selectedBooks));

  this.user.get('challenges').then(challenges => {
    assert.ok(component.addOrRemoveMustReadChallenge.calledWith([book], challenges));
  });
});
