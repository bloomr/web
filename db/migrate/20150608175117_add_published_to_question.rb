class AddPublishedToQuestion < ActiveRecord::Migration

  def up
    add_column :questions, :published, :bool, default: false
    execute 'update questions set published=TRUE'
  end

  def down
    remove_column :questions, :published, :bool
  end
end
