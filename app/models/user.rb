class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions
  accepts_nested_attributes_for :questions, :allow_destroy => true

  acts_as_taggable_on :keywords

  def love_job_answer
    answer = nil
    questions.each do |question|
      if question.identifier == "love_job"
        answer = question.answer
      end
    end
    return answer
  end
end
