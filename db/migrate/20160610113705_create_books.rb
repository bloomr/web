class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :author
      t.string :isbn
      t.string :title
      t.string :image_url

      t.timestamps null: false
    end
    add_index :books, :isbn, unique: true
  end
end
