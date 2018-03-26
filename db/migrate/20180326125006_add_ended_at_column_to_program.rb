class AddEndedAtColumnToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :ended_at, :datetime
  end
end
