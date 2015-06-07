class AddPositionToQuestions < ActiveRecord::Migration
  def up
    add_column :questions, :position, :string
    execute "UPDATE questions SET position = identifier;"

    #clean questions table to put constraint
    execute "delete from questions where answer = '';"

    execute <<-SQL
      ALTER TABLE questions ADD CONSTRAINT unique_user_id_identifier UNIQUE (user_id, identifier);
      update questions set identifier='love_job' where title like 'Au fond%';
      update questions set identifier='talk_to_your_15_self' where title like 'Aujourd''hui, qu%';
      update questions set identifier='how_multiple_jobs' where title like 'Aujourd''hui, vous %';
      update questions set identifier='specifically' where title like 'Concrètement,%';
      update questions set identifier='how_did_you_become' where title like 'Et comment%';
      update questions set identifier='what_is_your_job' where title like 'Et en quoi%';
      update questions set identifier='specifically' where title like 'Que faites%';
      update questions set identifier='what_made_you_start' where title like 'Vous êtes%';
      update questions set identifier='what_job_did_you_want_to_do' where title like 'Quand vous étiez%';
      update questions set identifier='something_to_add' where title like 'Une chose que%';
    SQL

  end

  def down
    execute "ALTER TABLE questions DROP CONSTRAINT unique_user_id_identifier;"
    remove_column :questions, :position, :string
  end
end
