import Ember from 'ember';

export default Ember.Component.extend({
  currentChallenge:  '',
  nameObserver: Ember.observer('name', function() {
    this.updateCurrentWidget();
  }),
  updateCurrentWidget() {
    if(!this.get('name')) {
      let nextChallenge = this.nextChallenge();
      this.get('updateName')(nextChallenge.get('query'));
      this.set('name', nextChallenge.get('query'));
      //for init, dont know
      this.set('currentChallenge', 'challenge-' + nextChallenge.get('query'));
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
    let nextChallenge = this.get('challenges')
      .sortBy('position')
      .find(c => !this.get('user.challenges').contains(c));
    if (!nextChallenge) {
      nextChallenge = Ember.Object.create({ widget: 'challenge-finish', query: 'finish' });
    }
    return nextChallenge;
  }
});
