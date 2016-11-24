class ChallengesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  after_create :sync_challenge_with_intercom

  private

  def sync_challenge_with_intercom
    Intercom::Wrapper.user_complete_challenge(challenge.name, Time.now.to_i, user_id)
  end
end
