import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'a',
  click() {
    Ember.$.ajax({
      url: '/users/sign_out',
      type: 'DELETE',
      success: () => {
        window.location = '/';
      }
    });
  }
});
