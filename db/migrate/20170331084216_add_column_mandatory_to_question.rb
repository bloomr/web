class AddColumnMandatoryToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :mandatory, :boolean, default: false
  end
end
