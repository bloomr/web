import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['image-upload', 'fileinput-button'],
  attributeBindings: ['style'],
  imageUrl: '',
  style: Ember.computed('imageUrl', function() {
    return Ember.String.htmlSafe(`background-image: url('${this.get('imageUrl')}');`);
  }),
  init() {
    this._super(...arguments);
    this.set('imageUrl', this.get('user.avatarUrl'));
  },
  displaySpinner() {
    this.set('imageUrl', 'assets/images/loader.gif');
  },
  updateImage(imageUrl) {
    this.set('imageUrl', imageUrl + new Date().getTime());
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
