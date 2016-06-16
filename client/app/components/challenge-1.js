import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service('store'),
  showIntro: true,
  showChoice: false,
  showSuccess: false,
  selectedTribes: [],
  init() {
    this._super(...arguments);
    this.get('store').findAll('tribe').then((tribes) => {
      this.set('tribes', tribes);
    });
    this.set('selectedTribes', this.get('user.tribes').toArray());
    if (this.get('user.challenges').findBy('name','the tribes')) {
      this.showOnly('Success');
    } else if (this.get('user.tribes.length') === 0) {
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
    this.get('user.tribes').setObjects(this.get('selectedTribes'));
    let tribesChallenge = this.get('challenges').findBy('name', 'the tribes');
    this.get('user.challenges').then((challenges) => {
      challenges.addObject(tribesChallenge);
      this.get('user').save();
    });
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
      this.showOnly('Success');
      this.updateUser();
    },
  }
});
