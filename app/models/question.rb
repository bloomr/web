class Question < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  belongs_to :user
  has_many :question_comments

  before_save :strip_injection_from_answer

  def published_questions
    question_comments.select {|q| q.published }
  end

  def discret_company_size
    return 2 if (self.answer == "Entre 11 et 250 personnes" or self.answer == "Entre 251 et 5000 personnes")
    return 3 if (self.answer == "Plus de 5000 personnes")
    return 1
  end

  scope :published, -> { where(questions: { published: true }) }
  def strip_injection_from_answer
    self.answer = sanitize(self.answer, tags: %w( b i br ul li ))
  end
end
