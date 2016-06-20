import QUnit from 'qunit';

let initCustomAssert = (context) => {
  QUnit.assert.templateContains = function(text, message) {
    var actual = context.$().text().includes(text);
    this.push(actual, context.$().text().trim(), text, message);
  };
};

export { initCustomAssert };
