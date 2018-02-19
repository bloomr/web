class AddUnicityConstraintsToKeywords < ActiveRecord::Migration
  def change
    add_index :keywords, :normalized_tag, unique: true
  end
end
