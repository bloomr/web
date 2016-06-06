import Ember from 'ember';

export default Ember.Component.extend({
  showIntro: true,
  showChoice: false,
  showSuccess: false,
  selectedTribes: [],
  init() {
    this._super(...arguments);
    this.set('selectedTribes', this.get('model.user.tribes').toArray());
    if (this.get('model.user.challenges').findBy('name','the tribes')) {
      this.showOnly('Success');
    } else if (this.get('model.user.tribes').length === 0) {
      this.showOnly('Choice');
    }
  },
  showOnly(name) {
    this.set('showIntro', false);
    this.set('showChoice', false);
    this.set('showSuccess', false);
    this.set('show' + name, true); 
  },
  actions: {
    tribeOK() {
      this.showOnly('Success');
    },
    tribeKO() {
      this.showOnly('Choice');
    },
    saveTribes() {
      this.get('model.user.tribes').setObjects(this.get('selectedTribes'));
      this.get('model.user').save();
      this.showOnly('Success');
    },
  }
});
