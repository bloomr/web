import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['questions-editor'],
  didInsertElement() {
    this._super(...arguments);
    this.$().on('trix-change', (e) => {
      Ember.run(() => {
        Ember.run.schedule('actions', () => {
          let trix = e.target;
          let questionId = trix.getAttribute('input');
          let text = trix.value;
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
      let question = this.get('questions').findBy('id', id);
      question.set('answer', text);
    }
  }
});
