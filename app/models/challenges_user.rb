class ChallengesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  after_create :sync_challenge_with_intercom

  private

  def sync_challenge_with_intercom
    Intercom::Wrapper.instance.user_complete_challenge(self)
  end
end
