import Ember from 'ember';

export default Ember.Component.extend({
  challengeService: Ember.inject.service(),
  store: Ember.inject.service(),
  showIntro: true,
  showForm: false,
  showSuccess: false,
  selectedStrengths: [],
  strengths: [],
  init() {
    this._super(...arguments);

    this.get('store').findAll('strength')
      .then(s => this.set('strengths', s));

    this.get('user.strengths')
      .then(strengths => strengths.toArray())
      .then(strengthsArray => this.set('selectedStrengths', strengthsArray));
  },
  showOnly(name) {
    this.set('showIntro', false);
    this.set('showForm', false);
    this.set('showSuccess', false);
    this.set('show' + name, true);
  },
  updateUser() {
    let user = this.get('user');
    let challengeService = this.get('challengeService');

    return user.setStrengths(this.get('selectedStrengths'))
      .then(u => challengeService.addChallenge(u, 'strengths'))
      .then(u => u.save())
      .then(() => user);
  },
  actions: {
    goToForm() {
        this.showOnly('Form');
    },
    saveStrengths() {
      if (this.get('selectedStrengths.length') !== 0) {
        this.showOnly('Success');
        this.updateUser();
      }
    }
  }
});
