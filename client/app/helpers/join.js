import Ember from 'ember';

export function join([array, prop]/*, hash*/) {
  if(!array || array.length === 0) { return ''; }

  let array_value = array.map(e => e.get(prop));
  if(array_value.length === 1) {
    return array_value[0];
  }

  let head = array_value.slice(0, -1);
  let tail = array_value[array_value.length -1];
  return head.join(', ') + " et " + tail;
}

export default Ember.Helper.helper(join);
