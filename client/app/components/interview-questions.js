import Ember from 'ember';

export default Ember.Component.extend({
  disabled: Ember.computed('user.hasDirtyAttributes', 'user.questions.@each.hasDirtyAttributes', function(){
    return !this.get('user.hasDirtyAttributes') &&
      this.get('user.questions').every((q) => !q.get('hasDirtyAttributes'));
  }),
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
