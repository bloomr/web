class AddDiscourseAndIntercomToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :discourse, :bool, null: true, default: false
    add_column :programs, :intercom, :bool, null: true, default: false
  end
end
