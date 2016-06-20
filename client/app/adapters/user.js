import JSONAPIAdapter from 'ember-data/adapters/json-api';

export default JSONAPIAdapter.extend({
  namespace: 'api/v1',
  buildURL (modelName, id, snapshot, requestType) {
    if(requestType === 'queryRecord') {
      return 'api/v1/me';
    } else {
      return this._super(...arguments);
    }
  }
});

