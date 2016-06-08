import JSONAPIAdapter from 'ember-data/adapters/json-api';

export default JSONAPIAdapter.extend({
  namespace: 'api/v1',
  handleResponse: function(status){
    if(status === 403){
      window.location = '/users/sign_in';
    }
    return this._super(...arguments);
  }
});
