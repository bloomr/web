import { make, makeList, manualSetup } from 'ember-data-factory-guy';
import { moduleFor, test } from 'ember-qunit';
import Ember from 'ember';

moduleFor('service:challenge-service', 'Unit | Service | challenge-service', {
  needs: ['model:challenge', 'model:user'],
  beforeEach() {
    manualSetup(this.container);
  }
});

test('add a challenge if it exists', function(assert) {
  let user = make('user');

  let challengesP = new Ember.RSVP.resolve(makeList('challenge', 3));
  let store = { findAll() { return challengesP; } };

  let service = this.subject({ store });

  return service.addChallenge(user, 'challenge0')
    .then(user => { return user.get('challenges'); })
    .then(challenges => { 
      assert.equal(challenges.get('length'), 1); 
    });
});
