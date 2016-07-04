import Ember from 'ember';

export default Ember.Component.extend({
  step1: true,
  step2: false,
  step3: false,
  showOnly(step){
    this.set('step1', false);
    this.set('step2', false);
    this.set('step3', false);
    this.set(step, true);
  },
  toggleDoAuthorize() {
    this.get('user').toggleProperty('doAuthorize');
  },
  actions: {
    displaySpinner() {
      this.set('user.avatarUrl', '');
    },
    updateImage(e, data) {
      this.set('user.avatarUrl', data.result.avatarUrl);
    },
    go_step1(){ this.showOnly('step1'); },
    go_step2(){ this.showOnly('step2'); },
    go_step3(){ this.showOnly('step3'); }
  }
});
