import Ember from 'ember';

export default Ember.Component.extend({
  done: Ember.computed('challenges', function() {
    return !!this.get('challenges').includes(this.get('challenge'));
  }),
});
