import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['profile-introduction'],
  classNameBindings: ['hidden'],
  hidden:  Ember.computed('user.challenges.@each', function() {
    return !!this.get('user.challenges').findBy('name', 'interview');
  })
});
