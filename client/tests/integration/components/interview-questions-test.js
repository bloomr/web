import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import { make, makeList, manualSetup } from 'ember-data-factory-guy';

moduleForComponent('interview-questions', 'Integration | Component | interview questions', {
  integration: true,
  beforeEach() {
    manualSetup(this.container);
    this.questions = makeList('question', 2);
    this.user = make('user', { questions: this.questions });
  }
});

//TODO complete
test('it renders', function(assert) {
  this.render(hbs`{{interview-questions user=user}}`);

  assert.equal(this.$('.job_title').val(), 'jobTitle');
});
