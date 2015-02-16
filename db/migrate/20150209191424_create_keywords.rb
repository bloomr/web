class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :tag
      t.text :description

      t.timestamps
    end

    create_table :keyword_associations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :keyword, index: true

      t.timestamps
    end
  end
end
