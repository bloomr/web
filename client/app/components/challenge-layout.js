import Ember from 'ember';

export default Ember.Component.extend({
  currentChallenge:  'challenge-interview',
  nameObserver: Ember.observer('name', function() {
    this.updateView();
  }),
  updateView() {
    if(!this.get('name')) { return 'challenge-interview'; }
    this.set('currentChallenge', 'challenge-' + this.get('name'));
  },
  reinitFlag: false,
  init() {
    this._super(...arguments);
    this.updateView();
  },
});
