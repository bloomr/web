import DS from 'ember-data';

export default DS.JSONAPISerializer.extend({
  attrs: {
    stats: { serialize: false },
    avatarUrl: { serialize: false }
  }
});
