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

  def published_questions
    question_comments.select {|q| q.published }
  end

  def discret_company_size
    return 2 if (self.answer == "Entre 11 et 250 personnes" or self.answer == "Entre 251 et 5000 personnes")
    return 3 if (self.answer == "Plus de 5000 personnes")
    return 1
  end

end
