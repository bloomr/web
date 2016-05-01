class SetWorkQuestionToPublished < ActiveRecord::Migration
  def change
    Question.where(identifier: Question::MY_WORK_QUESTIONS_IDENTIFIERS).each do |q|
      q.published = true
      q.save
    end
  end
end
