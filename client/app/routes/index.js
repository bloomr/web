import Ember from 'ember';

export default Ember.Route.extend({
  afterModel(model) {
    if (!model.user.get('challenges').findBy('name', 'interview')) {
      this.transitionTo('challenges');
    } else {
      this.transitionTo('whatsnew');
    }
  },
});
