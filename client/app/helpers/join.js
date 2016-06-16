import Ember from 'ember';

export function join([array, prop]/*, hash*/) {
  if(!array) { return; }
  return array.map(e => e.get(prop)).join(', ');
}

export default Ember.Helper.helper(join);
