class AddTribeToKeywords < ActiveRecord::Migration
  def change
    add_reference :keywords, :tribe, index: true
    add_foreign_key :keywords, :tribes
  end
end
