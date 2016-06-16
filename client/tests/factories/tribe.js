import FactoryGuy from 'ember-data-factory-guy';

FactoryGuy.define('tribe', {
  sequences: {
    tribeName: (num)=> `tribe${num}`
  },

  default: {
  name: FactoryGuy.generate('tribeName'),
  description: 'description',
  normalizedName: 'normalizedName',
  },
});
