import { moduleForComponent, test } from 'ember-qunit';
import { make, makeList, mockFindAll, manualSetup } from 'ember-data-factory-guy';
import sinon from 'sinon';

moduleForComponent('challenge-tribes', {
  unit: true,
  needs: ['model:user', 'model:challenge', 'model:tribe', 'service:challengeService'],
  beforeEach() {
    manualSetup(this.container);

    let user = make('user');
    user.save = sinon.stub();

    this.tribes = makeList('tribe', 3);
    mockFindAll('tribe').returns({models: this.tribes });

    let challengeService = { addChallenge: sinon.spy(u => u) };

    this.component = this.subject({user, challengeService});
  }
});

test('updateUser saves a added tribe, add tribe challenge and save user', function(assert) {
  this.component.selectedTribes = [this.tribes[0]];
  let challengeService = this.component.challengeService;

  return this.component.updateUser()
    .then(u => {
      assert.equal(u.get('tribes.length'), 1);
      assert.ok(challengeService.addChallenge.calledWith(u, 'the tribes'));
      assert.ok(u.save.called);
    });
});
