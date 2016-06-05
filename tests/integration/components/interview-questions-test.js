import Ember from 'ember';
import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('interview-questions', 'Integration | Component | interview questions', {
  integration: true,
  beforeEach() {
    let user = Ember.Object.create({ jobTitle: 'job', questions: [{ title: 't1', answer: 'r1'  }]  });
    this.set('model', Ember.Object.create({ user: user }));
  }
});

//TODO complete
test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{interview-questions model=model}}`);

  assert.equal(this.$('.job_title').val(), 'job');

});
