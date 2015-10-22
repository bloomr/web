class SetMyWorkQuestionsToPublished < ActiveRecord::Migration
  def change
    execute <<-SQL
      update questions set published='t' where identifier in ('how_many_people_in_company', 'solo_vs_team', 'who_do_you_work_with', 'foreign_language_mandatory', 'inside_or_outside_work', 'self_time_management');
    SQL
  end
end
