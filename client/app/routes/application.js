import Ember from 'ember';

export default Ember.Route.extend({
  client: Ember.inject.service('client-id'),
  model() {
    return Ember.RSVP.hash({
      user: this.store.findRecord('user', this.get('client').get(), { 'include': 'tribes,questions,challenges' }),
      tribes: this.store.findAll('tribe'),
      challenges: this.store.findAll('challenge')
    });
  }
});
