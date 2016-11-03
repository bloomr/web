import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { hasMany } from 'ember-data/relationships';

export default Model.extend({
  name: attr('string'),
  user: hasMany('user'),
  init() {
    if(this.get('name') === 'interview') {
      this.set('imageSrc', 'assets/images/profile/badge-profil.svg');
      this.set('description', 'Parlez-nous de votre métier');
      this.set('title', 'Témoignage');
      this.set('widget', 'challenge-interview');
      this.set('query', 'interview');
      this.set('position', 1);
    }
    if(this.get('name') === 'the tribes') {
      this.set('imageSrc', 'assets/images/profile/badge-tribu.svg');
      this.set('description', 'Dites-nous à quelle(s) tribu(s) vous appartenez');
      this.set('title', 'Tribu');
      this.set('widget', 'challenge-tribes');
      this.set('query', 'tribes');
      this.set('position', 2);
    }
    if(this.get('name') === 'must read') {
      this.set('imageSrc', 'assets/images/profile/badge-must-read.svg');
      this.set('description', 'le livre à lire absolument pour comprendre ce que je fais');
      this.set('title', 'Must Read');
      this.set('widget', 'challenge-mustread');
      this.set('query', 'mustread');
      this.set('position', 3);
    }
    if(this.get('name') === 'strengths') {
      this.set('imageSrc', 'assets/images/profile/badge-strength.png');
      this.set('description', 'les points forts qui me caractérisent');
      this.set('title', 'Mes forces');
      this.set('widget', 'challenge-strengths');
      this.set('query', 'strengths');
      this.set('position', 4);
    }
  }
});
