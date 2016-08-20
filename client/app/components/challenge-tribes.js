import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service('store'),
  showIntro: true,
  showChoice: false,
  showSuccess: false,
  challengeService: Ember.inject.service(),
  selectedTribes: [],
  reinitFlagChanged: Ember.observer('reinitFlag', function() { this.showOnly('Intro'); }),
  init() {
    this._super(...arguments);

    this.get('store').findAll('tribe')
      .then(t => this.set('tribes', t));

    this.get('user.tribes')
      .then(tribes => tribes.toArray())
      .then(tribesArray => this.set('selectedTribes', tribesArray));

    if (this.get('user.tribes.length') === 0) {
      this.showOnly('Choice');
    }
  },
  showOnly(name) {
    this.set('showIntro', false);
    this.set('showChoice', false);
    this.set('showSuccess', false);
    this.set('show' + name, true);
  },
  updateUser() {
    let user = this.get('user');
    let challengeService = this.get('challengeService');

    return user.setTribes(this.get('selectedTribes'))
      .then(u => challengeService.addChallenge(u, 'the tribes'))
      .then(u => u.save())
      .then(() => user);
  },
  actions: {
    tribeOK() {
      this.showOnly('Success');
      this.updateUser();
    },
    tribeKO() {
      this.showOnly('Choice');
    },
    saveTribes() {
      if (this.get('selectedTribes.length') !== 0) {
        this.showOnly('Success');
        this.updateUser();
      }
    },
  }
});
