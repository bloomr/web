import Ember from 'ember';

export default Ember.Component.extend({
  options: [],
  selectedKeywords: [],
  step2Enable: Ember.computed('user.isFirstInterviewAnswered', 'selectedKeywords.length', function(){
    return this.get('user.isFirstInterviewAnswered') && this.get('selectedKeywords.length') > 2;
  }),
  store: Ember.inject.service(),
  challengeService: Ember.inject.service(),
  step1: true,
  step2: false,
  step3: false,
  firstInterviewQuestions: null,
  observeStep: Ember.observer('step', function(){
    this.updateView();
  }),
  updateView() {
    if(!this.get('step')) { this.set('step', 1); }
    this.showOnly('step' + this.get('step'));
  },
  init() {
    this._super(...arguments);
    this.updateView();
    //copy of those manyArray to be able to add none model safely
    this.get('store').findAll('keyword', {reload: true}).then(keywords => {
      this.set('options', keywords.toArray());
    });
    this.get('user.keywords').then(keywords => {
      this.set('selectedKeywords', keywords.toArray());
    });
    this.get('user').questions_by_step('first_interview')
      .then(questions => this.set('firstInterviewQuestions', questions));
  },
  showOnly(step){
    this.set('step1', false);
    this.set('step2', false);
    this.set('step3', false);
    this.set(step, true);
  },
  toggleDoAuthorize() {
    this.get('user').toggleProperty('doAuthorize');
  },
  saveNewKeywords(keywords) {
    return keywords.map(keyword => {
      //if its a keyword model (it has the save method) we dont record it
      if (keyword.save) { return keyword; }
      return this.get('store').createRecord('keyword', keyword.getProperties('tag')).save();
    });
  },
  saveKeywordsAndUser() {
    let keywordRecordsPromises = this.saveNewKeywords(this.get('selectedKeywords'));

    Ember.RSVP.Promise.all(keywordRecordsPromises).then(keywordRecords => {
      this.set('user.keywords', keywordRecords);
      this.get('user.questions').forEach(q => q.save());
      this.get('user').save();
    });
  },
  saveChallengeAndUser() {
    return  this.get('challengeService')
      .addChallenge(this.get('user'), 'interview')
      .then(u => u.save());
  },
  actions: {
    displaySpinner() {
      this.set('user.avatarUrl', '');
    },
    updateImage(e, data) {
      this.set('user.avatarUrl', data.result.avatarUrl);
    },
    go_step2(){
      this.saveKeywordsAndUser();
      this.set('step', '2');
      document.querySelectorAll('.challenge-interview')[0].scrollIntoView();
    },
    go_step3(){ 
      this.saveChallengeAndUser();
      this.set('step', '3');
    }
  }
});
