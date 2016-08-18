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
  }
});
