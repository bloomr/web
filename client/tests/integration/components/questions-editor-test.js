import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { makeList, manualSetup } from 'ember-data-factory-guy';
import { initCustomAssert } from '../../assertions/custom';

moduleForComponent('questions-editor', 'Integration | Component | questions editor', {
  integration: true,
  beforeEach() {
    manualSetup(this.container);
    this.set('questions', makeList('question', 1, { description: 'question description' }));
    initCustomAssert(this);
  }
});

test('it renders the title and the description', function(assert) {
  this.render(hbs`{{questions-editor questions=questions}}`);

  assert.templateContains('questionTitle1');
  assert.equal(this.$('trix-editor').attr('placeholder'), 'question description');
});

test('it refresh the user answer', function(assert) {
  this.render(hbs`{{questions-editor questions=questions}}`);

  this.$('input#1').val('answer1');
  this.$('trix-editor').trigger('trix-change');

  assert.equal(this.get('questions').objectAt(0).get('answer'), 'answer1');
});
