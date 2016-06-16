import Ember from 'ember';

export default Ember.Controller.extend({
  currentChallenge: 'challenge-1',
  actions: {
    setCurrentChallenge(challenge) {
      this.set('currentChallenge', challenge.get('widget'));
    }
  }
});
