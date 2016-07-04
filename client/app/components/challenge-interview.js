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
  displaySpinner() {
    this.set('user.avatarUrl', '');
  },
  updateImage(imageUrl) {
    this.set('user.avatarUrl', imageUrl);
  },
  didInsertElement() {
    this._super(...arguments);
    let self = this;
    this.$('.fileupload').fileupload({
      dataType: 'json',
      maxChunkSize: 400000, //400k
      start() { self.displaySpinner(); },
      done(e, data) { self.updateImage(data.result.avatarUrl); },
      add: function (e, data) {
        var uploadFile = data.files[0];
        if (!(/\.(gif|jpg|jpeg|tiff|png)$/i).test(uploadFile.name)) {
          alert('You must select an image file only');
        }
        if (uploadFile.size > 200000) { // 2mb
          alert('Please upload a smaller image, max size is 2 MB');
        }
        else {
          data.submit();
        }
      },
    });

  },
  willDestroyElement() {
    this._super(...arguments);
    this.$('#fileupload').fileupload('destroy');
  },
  toggleDoAuthorize() {
    this.get('user').toggleProperty('doAuthorize');
  },
  actions: {
    go_step1(){
      this.showOnly('step1');
    },
    go_step2(){
      this.showOnly('step2');
    },
    go_step3(){
      this.showOnly('step3');
    }
  }
});
