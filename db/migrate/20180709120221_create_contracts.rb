class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :company_name, null: false
      t.string :key, null: false

      t.timestamps null: false
    end
    add_index :contracts, :company_name, unique: true
    add_index :contracts, :key, unique: true
  end
end
