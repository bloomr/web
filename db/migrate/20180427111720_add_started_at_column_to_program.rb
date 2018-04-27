class AddStartedAtColumnToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :started_at, :datetime
  end
end
