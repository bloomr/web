import Ember from 'ember';

export default Ember.Component.extend({
  description: Ember.computed('user.challenges.length', function() {
    let nb = this.get('user.challenges.length');
    if (nb === 0) { return '1 challenge'; }
    else { return `${nb + 1} challenges`; }
  }),
  mustReadChallenge: Ember.computed(function() {
    return this.get('challenges').findBy('name', 'must read');
  }),
  tribeChallenge: Ember.computed(function() {
    return this.get('challenges').findBy('name', 'the tribes');
  })
});
