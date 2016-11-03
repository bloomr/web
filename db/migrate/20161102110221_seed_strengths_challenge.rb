class SeedStrengthsChallenge < ActiveRecord::Migration
  def change
    Challenge.create(name: 'strengths')
  end
end
