class AddStepToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :step, :string
  end
end
