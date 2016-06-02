import Ember from 'ember';

export default Ember.Route.extend({
  model() { 
    return this.store.findRecord('user', 12);
    // return {"id":12,"first_name":"Simon","job_title":"Consultant en Informatique"}; 
    }
});
