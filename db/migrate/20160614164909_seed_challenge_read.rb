class SeedChallengeRead < ActiveRecord::Migration
  def change
    Challenge.create(name: 'must read')
  end
end
