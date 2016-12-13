class AddNormalizedTagToKeyword < ActiveRecord::Migration
  def change
    add_column :keywords, :normalized_tag, :string
  end
end
