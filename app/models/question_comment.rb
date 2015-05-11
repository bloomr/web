class QuestionComment < ActiveRecord::Base
  belongs_to :question

  validates :comment, :presence => true
  validates :author_name, :presence => true
end
