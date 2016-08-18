import FactoryGuy from 'ember-data-factory-guy';

FactoryGuy.define('challenge', {
  sequences: {
    challengeName: (num) => `challenge${num - 1}`
  },
  default: {
    name: FactoryGuy.generate('challengeName')
  },
});
