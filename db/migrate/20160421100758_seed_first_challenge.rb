class SeedFirstChallenge < ActiveRecord::Migration
  def change
    Challenge.create({ name: 'the tribes'})
  end
end
