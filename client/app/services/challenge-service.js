import Ember from 'ember';

export default Ember.Service.extend({
  store: Ember.inject.service(),
  challengesPromise: null,
  init() {
    this._super(...arguments);
    this.set('challengesPromise', this.get('store').findAll('challenge'));
  },
  addChallenge(user, name) {
    return this.get('challengesPromise').then(allChallenges => {
      return user.addChallenge(allChallenges.findBy('name', name));
    });
  },
  updateMustReadChallenge(user) {
    return this.get('challengesPromise')
      .then(challenges => { 
        return Ember.RSVP.Promise.all([
          challenges.findBy('name', 'must read'), user.get('books')]); 
      })
      .then(([mustRead, books]) => {
        if(books.length !== 0) {
          return user.addChallenge(mustRead);
        } else {
          return user.removeChallenge(mustRead);
        }
      })
      .then(() => user);
  },
});
