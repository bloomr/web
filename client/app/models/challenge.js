import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { hasMany } from 'ember-data/relationships';

export default Model.extend({
  name: attr('string'),
  user: hasMany('user'),
  init() {
    if(this.get('name') === 'interview') {
      this.set('imageSrc', 'assets/images/profile/badge-profil.svg');
      this.set('description', 'Réalisez votre interview');
      this.set('title', 'Témoignage');
      this.set('widget', 'challenge-interview');
      this.set('query', 'interview');
    }
    if(this.get('name') === 'must read') {
      this.set('imageSrc', 'assets/images/profile/badge-must-read.svg');
      this.set('description', 'le livre à lire absolument pour comprendre ce que je fais');
      this.set('title', 'Must Read');
      this.set('widget', 'challenge-2');
      this.set('query', '2');
    }
    if(this.get('name') === 'the tribes') {
      this.set('imageSrc', 'assets/images/profile/badge-tribu.svg');
      this.set('description', 'Dites-nous à quelle(s) tribu(s) vous appartenez');
      this.set('title', 'Tribu');
      this.set('widget', 'challenge-tribes');
      this.set('query', 'tribes');
    }
  }
});
