class CreateBloomies < ActiveRecord::Migration
  def change
    create_table :bloomies do |t|

      t.timestamps null: false
    end
  end
end
