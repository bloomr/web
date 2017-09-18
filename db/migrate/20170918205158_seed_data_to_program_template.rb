class SeedDataToProgramTemplate < ActiveRecord::Migration
  def change
    ProgramTemplate.create(name: 'standard', discourse: true, intercom: false)
    ProgramTemplate.create(name: 'premium',  discourse: true, intercom: true)
  end
end
