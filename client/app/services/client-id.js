import Ember from 'ember';

export default Ember.Service.extend({
  get() {
    return window.Cookies.get('id');
  }
});
