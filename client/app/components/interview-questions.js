import Ember from 'ember';

export default Ember.Component.extend({
  firstQuestions: null,
  disabled: Ember.computed('user.hasDirtyAttributes', 'user.questions.@each.hasDirtyAttributes', function(){
    return !this.get('user.hasDirtyAttributes') &&
      this.get('user.questions').every((q) => !q.get('hasDirtyAttributes'));
  }),
  init() {
    this._super(...arguments);
    this.get('user').questions_by_step('first_interview')
      .then(q => this.set('firstQuestions', q));
  },
  actions: {
    save() {
      this.get('user.questions').then( qs => { 
        qs.filterBy('hasDirtyAttributes').forEach(q => q.save());
      });

      let user = this.get('user');
      if(user.get('hasDirtyAttributes')) { user.save(); }
    }
  }
});
