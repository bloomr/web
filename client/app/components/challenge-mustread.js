import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  bookSearch: Ember.inject.service(),
  challengeService: Ember.inject.service(),
  keywords: '',
  books: Ember.ArrayProxy.create({ content: [] }),
  selectedBooks: Ember.ArrayProxy.create({ content: [] }),
  showSearch: true,
  showSelection: false,
  showDone: false,
  showWaiting: false,
  showResults: false,
  inEnglish: false,
  reinitFlagChanged: Ember.observer('reinitFlag', function() { this.showOnly('Selection'); }),
  resultPresentation: Ember.computed('books.length', function(){
    let bookNb = this.get('books.length');
    if (bookNb === 0) {
      return 'heu ... pas de résultat ...';
    } else if (bookNb === 1) {
      return '1 résultat';
    }
    return `${bookNb} resultats :`;
  }),
  init() {
    this._super(...arguments);
    this.get('user.books').then(books => {
      if(books.length > 0) {
        this.set('selectedBooks', books.toArray());
        this.showOnly('Selection');
      }
    });
  },
  showOnly(name) {
    this.set('showSearch', false);
    this.set('showSelection', false);
    this.set('showDone', false);
    this.set('showWaiting', false);
    this.set('showResults', false);
    this.set('show' + name, true);
  },
  saveNewBooks(books) {
    return Ember.RSVP.Promise.all(books.map(book => {
      //if its a book model (it has the get method) we dont record it
      if (book.get) { return book; }
      return this.get('store').createRecord('book', book).save();
    }));
  },
  saveBookAndUser() {
    let user = this.get('user');
    let challengeService = this.get('challengeService');
    let books = this.get('selectedBooks');

    return this.saveNewBooks(books)
      .then(books => user.setBooks(books))
      .then(user => challengeService.updateMustReadChallenge(user))
      .then(u => u.save())
      .then(() => user);
  },
  actions: {
    search() {
      this.set('showWaiting', true);
      this.set('showResults', false);
      this.get('bookSearch').search(this.get('keywords'), { inEnglish: this.get('inEnglish') })
        .then(data => {
          this.set('showWaiting', false);
          this.set('showResults', true);
          this.set('books.content', data);
        });
    },
    addBook(book) {
      this.get('selectedBooks').addObject(book);
      this.showOnly('Selection');
    },
    removeBook(book) {
      this.get('selectedBooks').removeObject(book);
      this.saveBookAndUser();
      if (this.get('selectedBooks.length') === 0) {
        this.showOnly('Search');
      }
    },
    oneAgain() {
      this.showOnly('Search');
    },
    done() {
      this.showOnly('Done');
      this.saveBookAndUser();
    }
  }
});
