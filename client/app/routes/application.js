import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return Ember.RSVP.hash({
      user: this.store.queryRecord('user', {}),
      tribes: this.store.findAll('tribe'),
      challenges: this.store.findAll('challenge')
    });
  }
});
