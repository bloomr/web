import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: ['name', 'step'],
  name: null,
  step: null,
  actions: {
    updateName(name) {
      this.set('name', name);
    }
  }
});
