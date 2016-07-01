class SeedInterviewChallenge < ActiveRecord::Migration
  def change
    Challenge.create(name: 'interview')
  end
end
