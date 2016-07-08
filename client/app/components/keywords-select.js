import Ember from 'ember';
import { stripDiacritics } from 'ember-power-select/utils/group-utils';

export default Ember.Component.extend({
  selected: [],
  buildSuggestion(term) {
    return `ajouter ${term}`;
  },
  actions: {
    search(term) {
      if(term && term.length > 1 ) {
        let normalized_term = stripDiacritics(term.toLowerCase());
        return this.get('options').filter(o => stripDiacritics(o.get('tag').toLowerCase()).indexOf(normalized_term) > -1);
      }
      return [];
    },
    createKeyword(tag) {
      let selected = this.get('selected');
      tag = tag.replace(/(?:^|\s)\S/g, function(a) { return a.toUpperCase();  });
      let toAdd = Ember.Object.create({ tag: tag });
      if (!selected.findBy('tag', toAdd.get('tag'))) {
        this.get('options').addObject(toAdd);
        selected.addObject(toAdd);
      }
    }
  }
});
