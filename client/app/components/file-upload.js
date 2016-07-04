import Ember from 'ember';

export default Ember.Component.extend({
  didInsertElement() {
    this._super(...arguments);
    let self = this;
    this.$('.fileupload').fileupload({
      dataType: 'json',
      start() { self.get('start')(); },
      done(e, data) { self.get('done')(e, data); }
    });
  },
  willDestroyElement() {
    this._super(...arguments);
    this.$('#fileupload').fileupload('destroy');
  },
});
