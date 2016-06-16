import Ember from 'ember';

export default Ember.Component.extend({
  done: Ember.computed('challenges', function() {
    return !!this.get('challenges').contains(this.get('challenge'));
  }),
  actions: {
    selectChallenge() {
      this.get('onClick')(this.get('challenge'));
    }
  }
});
