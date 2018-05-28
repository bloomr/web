class CreateBundles < ActiveRecord::Migration
  def change
    create_table :bundles do |t|
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :bundles, :name, unique: true
  end
end
