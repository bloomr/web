import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['image-upload', 'fileinput-button'],
  attributeBindings: ['style'],
  imageUrl: Ember.computed('user.avatarUrl', function() {
    let avatarUrl = this.get('user.avatarUrl');
    if(avatarUrl === '') { return 'assets/images/loader.gif'; }
    if(avatarUrl) { return avatarUrl; }
    return '';
  }),
  style: Ember.computed('imageUrl', function() {
    return Ember.String.htmlSafe(`background-image: url('${this.get('imageUrl')}');`);
  }),
  displaySpinner() {
    this.set('user.avatarUrl', '');
  },
  updateImage(avatarUrl) {
    this.set('user.avatarUrl', avatarUrl);
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
