import Ember from 'ember';

export default Ember.Controller.extend({
  currentChallenge: 'challenge-1',
  reinitFlag: false,
  actions: {
    setCurrentChallenge(challenge) {
      if (this.get('currentChallenge') !== challenge.get('widget')) {
        this.set('currentChallenge', challenge.get('widget'));
      } else {
        this.toggleProperty('reinitFlag');
      }
    }
  }
});
