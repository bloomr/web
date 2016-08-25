import { make, makeList, manualSetup } from 'ember-data-factory-guy';
import { moduleFor, test } from 'ember-qunit';
import Ember from 'ember';

moduleFor('service:challenge-service', 'Unit | Service | challenge-service', {
  needs: ['model:challenge', 'model:user', 'model:book'],
  beforeEach() {
    manualSetup(this.container);

    let [interview, tribes, mustRead] = 
      makeList('challenge', {name: 'interview'}, {name: 'tribes'}, {name: 'must read'});

    let challengesP = new Ember.RSVP.resolve([interview, tribes, mustRead]);
    let store = { findAll() { return challengesP; } };

    this.service = this.subject({ store });
    this.mustRead = mustRead;
  }
});

test('add a challenge if it exists', function(assert) {
  let user = make('user');

  return this.service.addChallenge(user, 'interview')
    .then(user => user.get('challenges'))
    .then(challenges => assert.equal(challenges.get('length'), 1));
});

test('updateMustReadChallenge removes challenge if not books left', function(assert) {
  let user = make('user', { challenges: [this.mustRead] } );

  return this.service.updateMustReadChallenge(user)
    .then(u => u.get('challenges'))
    .then(c => assert.equal(c.length, 0));
});

test('updateMustReadChallenge add challenge if at least a book', function(assert) {
  let user = make('user', { challenges: [this.mustRead], books: [make('book')] } );

  return this.service.updateMustReadChallenge(user)
    .then(u => u.get('challenges'))
    .then(c => assert.equal(c.length, 1));
});

