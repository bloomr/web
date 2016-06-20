import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return Ember.RSVP.hash({
      user: this.store.queryRecord('user', {}),
      tribes: this.store.findAll('tribe'),
      challenges: this.store.findAll('challenge')
    });
  },
  actions: {
    error(error) {
      if (error && error.isAdapterError) {
        let status = error.errors[0].status;
        if(status === '403' || status === '401'){
          window.location = '/users/sign_in';
        }
      }
    }
  }
});
