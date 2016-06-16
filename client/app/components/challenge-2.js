import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service('store'),
  keywords: '',
  books: Ember.ArrayProxy.create({ content: [] }),
  selectedBooks: Ember.ArrayProxy.create({ content: [] }),
  showSearch: true,
  showSelection: false,
  showDone: false,
  showWaiting: false,
  showResults: false,
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
  saveBookAndUser() {
    let bookRecordsPromises = this.get('selectedBooks').map(book => {
      //if its a book model (it has the get model) we dont record it
      if (book.get) {
        return book;
      }
      let record = this.get('store').createRecord('book', book);
      return record.save();
    });

    Promise.all(bookRecordsPromises).then(bookRecords => {
      this.set('user.books', bookRecords);
      let user = this.get('user');

      let mustReadChallenge = this.get('challenges').findBy('name', 'must read');

      user.get('challenges').then((challenges) => {
        challenges.pushObject(mustReadChallenge);
        user.save();
      });
    });
  },
  actions: {
    search() {
      this.set('showWaiting', true);
      this.set('showResults', false);
      let keywords = this.get('keywords');
      Ember.$.get('/api/v1/books/search?keywords='+keywords).done(data => {
        this.set('showWaiting', false);
        this.set('showResults', true);
        this.set('books.content', data);
      });
    },
    addBook(book) {
      this.get('selectedBooks').pushObject(book);
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
