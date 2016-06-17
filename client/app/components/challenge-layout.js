import Ember from 'ember';

export default Ember.Component.extend({
  currentChallenge: 'challenge-1',
  reinitFlag: false,
  setup: Ember.on('init', function() {
    this.get('model.user.challenges').then((challenges) => {
      if(challenges.findBy('name', 'the tribes')) {
        this.set('currentChallenge', 'challenge-2');
      }
    });
  }),
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
