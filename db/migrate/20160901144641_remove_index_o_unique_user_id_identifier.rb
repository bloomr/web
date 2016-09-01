class RemoveIndexOUniqueUserIdIdentifier < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE questions DROP CONSTRAINT unique_user_id_identifier;'
  end
end
