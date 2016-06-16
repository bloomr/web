import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { hasMany } from 'ember-data/relationships';

export default Model.extend({
  name: attr('string'),
  user: hasMany('user'),
  init() {
    if(this.get('name') === 'must read') {
      this.set('imageSrc', 'assets/images/profile/badge-must-read.svg');
      this.set('description', 'Partage les bouquins à découvrir');
      this.set('title', 'Must Read');
      this.set('widget', 'challenge-2');
    }
    if(this.get('name') === 'the tribes') {
      this.set('imageSrc', 'assets/images/profile/badge-tribu.svg');
      this.set('description', 'Dis nous à quelle tribu tu appartiens');
      this.set('title', 'Tribu');
      this.set('widget', 'challenge-1');
    }
  }
});
