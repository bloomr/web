class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string :prismic_id
      t.timestamps null: false
      t.index [:prismic_id], unique: true
    end
  end
end
