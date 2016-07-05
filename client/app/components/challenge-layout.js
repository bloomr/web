import Ember from 'ember';

export default Ember.Component.extend({
  currentChallenge:  '',
  nameObserver: Ember.observer('name', function() {
    this.updateCurrentWidget();
  }),
  updateCurrentWidget() {
    if(!this.get('name')) { 
      this.set('currentChallenge', this.nextChallenge().get('widget')); 
    } else {
      this.set('currentChallenge', 'challenge-' + this.get('name'));
    } 
  },
  reinitFlag: false,
  init() {
    this._super(...arguments);
    this.updateCurrentWidget();
  },
  nextChallenge(){
    return this.get('challenges')
      .sortBy('position')
      .find(c => !this.get('user.challenges').contains(c));
  }
});
