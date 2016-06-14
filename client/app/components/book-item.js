import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    click: function() {
      this.get('onClick')(this.get('book'));
    }
  }
});
