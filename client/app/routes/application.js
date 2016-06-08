import Ember from 'ember';

export default Ember.Route.extend({
  model() { 
    return Ember.RSVP.hash({
      user: this.store.findRecord('user', 12, { 'include': 'tribes,questions' }),
      tribes: this.store.findAll('tribe')
    });
  }
});
