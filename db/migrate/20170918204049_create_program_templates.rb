class CreateProgramTemplates < ActiveRecord::Migration
  def change
    create_table :program_templates do |t|
      t.string :name, null: false
      t.boolean :discourse, null: false
      t.boolean :intercom, null: false

      t.timestamps null: false
    end
    add_index :program_templates, :name, unique: true
  end
end
