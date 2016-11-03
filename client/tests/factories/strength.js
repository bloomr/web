import FactoryGuy from 'ember-data-factory-guy';

FactoryGuy.define('strength', {
  sequences: {
    strengthName: (num) => `strength${num - 1}`
  },
  default: {
    name: FactoryGuy.generate('strengthName')
  },
});
