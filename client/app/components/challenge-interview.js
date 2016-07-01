import Ember from 'ember';

export default Ember.Component.extend({
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
      start() { self.displaySpinner(); },
      done(e, data) { self.updateImage(data.result.avatarUrl); }
    });
  },
  willDestroyElement() {
    this._super(...arguments);
    this.$('#fileupload').fileupload('destroy');
  },
});
