class Stat
  def self.engagement_rate
    user_count = User.count
    challenge_count = Challenge.count
    challenge_complete_count = ChallengesUser.count

    return 0 if challenge_count == 0 || user_count == 0

    ((challenge_complete_count.to_f / (challenge_count * user_count)) * 100).round
  end
end
