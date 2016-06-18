import Ember from 'ember';

export default Ember.Component.extend({
  click: function() {
    this.get('onClick')(this.get('book'));
  }
});
