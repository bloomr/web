import Ember from 'ember';

export default Ember.Component.extend({
  didInsertElement() {
    this._super(...arguments);
    this.$().on('trix-change', (e) => {
      Ember.run(() => {
        Ember.run.schedule('actions', () => {
          let questionId = e.originalEvent.srcElement.getAttribute('input');
          let text = e.originalEvent.srcElement.value;
          this.actions.updateQuestion.call(this, questionId, text);
        });
      }); 
    });
  },
  willDestroyElement() {
    this._super(...arguments);
    this.$().off('trix-change');
  },
  actions: {
    updateQuestion(id, text) {
      let question = this.get('model.user.questions').findBy('id', id);
      question.set('answer', text);
    },
    save() {
      this.get('model.user.questions').then((q) => q.save());
    }
  }
});
