class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions
  accepts_nested_attributes_for :questions, :allow_destroy => true

  acts_as_taggable_on :keywords

  has_attached_file :avatar, styles: {
      thumb: '100x100#',
  }
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def love_job_answer
    question = questions.find {|q| q.identifier == 'love_job'}
    question.answer if question
  end

  def specifically
    question = questions.find {|q| q.identifier == 'specifically'}
    question.answer if question
  end
end
