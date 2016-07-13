class AddAsinToBook < ActiveRecord::Migration
  def change
    add_column :books, :asin, :string
  end
end
