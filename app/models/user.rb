class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  is_impressionable

  has_many :questions
  accepts_nested_attributes_for :questions, :allow_destroy => true

  acts_as_taggable_on :keywords

  has_many :keyword_associations
  accepts_nested_attributes_for :keyword_associations, :allow_destroy => true
  has_many :keywords, :through => :keyword_associations
  accepts_nested_attributes_for :keywords, :allow_destroy => true

  has_attached_file :avatar, styles: {
    thumb: '100x100#',
  }

  has_and_belongs_to_many :tribes

  before_post_process :rename_avatar
  def rename_avatar
    #avatar_file_name - important is the first word - avatar - depends on your column in DB table
    extension = File.extname(avatar_file_name).downcase
    self.avatar.instance_write :file_name, "#{Time.now.to_i.to_s}#{extension}"
  end

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  include AlgoliaSearch

  algoliasearch index_name: "User_#{ENV['ALGOLIA_ENV']}", if: :published do
    attribute :first_name, :job_title
    attribute :keywords do
      keywords.map { |k| k.tag }
    end
    attribute :questions do
      questions.map { |q| { answer: q.answer } }
    end
  end

  def answer_to question_id
    question = questions.find {|q| q.identifier == question_id}
    question.answer if question
  end

  def is_keyword_popular keyword
    return KeywordAssociation.where(:keyword => keyword).count >= 2
  end

  def self.next current_id
    self.where("id > ? and published = ?", current_id, true).order(id: :asc).first() || self.where("published = ?", true).order(id: :asc).first()
  end

  def self.previous current_id
    self.where("id < ? and published = ?", current_id, true).order(id: :desc).first() || self.where("published = ?", true).last
  end

  def self.random
    offset = rand(self.where("published = ? and job_title IS NOT NULL", true).count())
    self.where("published = ? and job_title IS NOT NULL", true).offset(offset).first
  end

  MY_WORK_QUESTIONS_IDENTIFIERS = %w{how_many_people_in_company solo_vs_team who_do_you_work_with foreign_language_mandatory inside_or_outside_work self_time_management always_on_the_road manual_or_intellectual }

  def questions_to_display
    questions_not_to_display = MY_WORK_QUESTIONS_IDENTIFIERS + ['love_job']
    questions.select {|q| q.published && !questions_not_to_display.include?(q.identifier) }
  end

  def self.find_published_with_love_job_question options={}
    options = { nb_per_page: 12, page: 0}.merge(options)

    users = User.select("users.id, count(questions.id) AS questions_count")
    .joins(:questions)
    .where(users: {published: true}, questions: {published: true})
    .group('users.id, questions.user_id')
    .order("questions_count DESC, users.id DESC")
    .limit(options[:nb_per_page])
    .offset(options[:nb_per_page] * options[:page])

    user_with_questions = User.includes(:questions).where(questions: {identifier: 'love_job'}, users: {id: [ users.map{|u| u.id } ].flatten })

    users.map{|u| user_with_questions.select{|uq| uq.id == u.id }.first }.compact
  end

  def self.find_published_with_tag options={}
    options = { nb_per_page: 12, page: 0}.merge(options)

    User.joins(:keywords)
    .where('users.published = ? and users.job_title IS NOT NULL AND keywords.tag = ?', true, options[:tag])
    .select('distinct users.*')
    .limit(12)
    .offset(options[:nb_per_page] * options[:page])
    .order(updated_at: :desc)
  end

  def has_explained_its_works?
    MY_WORK_QUESTIONS_IDENTIFIERS.all? {|identifier| questions.find { |q2| q2.identifier == identifier } }
  end

  def last_month_view_count
    impressionist_count(start_date: Date.today.beginning_of_month.last_month, end_date: Date.today.beginning_of_month)
  end

  # returns default tribes order based on keywords
  def default_tribes
    hash = keywords.map(&:tribe).inject(Hash.new(0)) { |h,tribe| h[tribe] += 1; h }
    hash.delete(nil)
    hash.to_a.sort_by{ |e| e[1] }.reverse.map{ |e| e[0] }
  end

end
