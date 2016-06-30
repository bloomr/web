import FactoryGuy from 'ember-data-factory-guy';

FactoryGuy.define('question', {
  sequences: {
    questionTitle: (num) => `questionTitle${num}`
  },

  default: {
    title: FactoryGuy.generate('questionTitle')
  },
});
