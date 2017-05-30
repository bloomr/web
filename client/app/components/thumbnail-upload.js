import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['thumbnail-upload', 'fileinput-button'],
  attributeBindings: ['style'],
  imageUrl: Ember.computed('user.avatarUrl', function() {
    let avatarUrl = this.get('user.avatarUrl');
    if(avatarUrl === '') { return '/assets/images/loader.gif'; }
    if(avatarUrl) { return avatarUrl; }
    return '';
  }),
  style: Ember.computed('imageUrl', function() {
    return Ember.String.htmlSafe(`background-image: url('${this.get('imageUrl')}');`);
  }),
  actions: {
    displaySpinner() {
      this.set('user.avatarUrl', '');
    },
    updateImage(e, data) {
      this.set('user.avatarUrl', data.result.avatarUrl);
    },
  }
});
