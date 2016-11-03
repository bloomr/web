import Ember from 'ember';

export default Ember.Component.extend({
  description: Ember.computed('user.challenges.length', function() {
    let nb = this.get('user.challenges.length');
    if (nb === 0) { return "vous n'avez pas encore relevé de challenge"; }
    if (nb === 1) { return "vous avez relevé 1 challenge"; }
    return `vous avez relevé ${nb} challenges`;
  }),
  mustReadChallenge: Ember.computed(function() {
    return this.get('challenges').findBy('name', 'must read');
  }),
  interviewChallenge: Ember.computed(function() {
    return this.get('challenges').findBy('name', 'interview');
  }),
  tribeChallenge: Ember.computed(function() {
    return this.get('challenges').findBy('name', 'the tribes');
  }),
  strengthsChallenge: Ember.computed(function() {
    return this.get('challenges').findBy('name', 'strengths');
  })
});
