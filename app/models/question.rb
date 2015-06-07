class Question < ActiveRecord::Base
  belongs_to :user
  has_many :question_comments

  def <=> other_question
    if position.length == 0
      return +1
    end

    if other_question.position.length == 0
      return -1
      end

    position <=> other_question.position
  end
end
