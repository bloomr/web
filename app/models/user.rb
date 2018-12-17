class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  is_impressionable

  has_many :questions
  accepts_nested_attributes_for :questions, allow_destroy: true

  has_many :interview_questions, -> {
    where('identifier IS NULL or identifier NOT IN (?)', Question::NOT_INTERVIEW_QUESTIONS)
      .order(position: :asc)
  }, class_name: 'Question'

  has_many :keyword_associations
  accepts_nested_attributes_for :keyword_associations, allow_destroy: true
  has_many :keywords, through: :keyword_associations
  accepts_nested_attributes_for :keywords, allow_destroy: true

  has_attached_file :avatar, styles: {
    thumb: '100x100#'
  }

  before_save :check_published, :clean_first_name_and_job_title, :normalize_job_title, :normalize_first_name
  after_save :sync_with_intercom

  has_and_belongs_to_many :tribes

  has_many :challengesUsers
  has_many :challenges, through: :challengesUsers
  has_and_belongs_to_many :books
  has_and_belongs_to_many :strengths

  before_post_process :rename_avatar
  def rename_avatar
    extension = File.extname(avatar_file_name).downcase
    avatar.instance_write :file_name, "#{Time.now.to_i}#{extension}"
  end

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  include AlgoliaSearch

  algoliasearch index_name: "User_#{ENV['ALGOLIA_ENV']}", disable_indexing: Rails.env.test?, if: :published do
    attribute :first_name, :job_title
    attribute :avatar_url do
      avatar.url('thumb')
    end
    attribute :keywords do
      keywords.map(&:tag)
    end
    attribute :questions do
      questions.map { |q| { answer: q.answer } }
    end
  end

  # by default the questions are published by default to ease
  # the human validation step
  def self.create_with_default_questions!(params)
    user = User.new(params)
    user.questions += Question.first_interview_canonicals.map(&:dup)
    user.questions.each { |e| e.published = true }
    user.save!
    user
  end

  def answer_to(question_id)
    question = questions.find { |q| q.identifier == question_id }
    question.answer if question
  end

  def self.next(current_id)
    where('id > ? and published = ?', current_id, true).order(id: :asc).first ||
      where('published = ?', true).order(id: :asc).first
  end

  def self.previous(current_id)
    where('id < ? and published = ?', current_id, true)
      .order(id: :desc).first ||
      where('published = ?', true).last
  end

  def self.random
    offset = rand(where('published = ? and job_title IS NOT NULL', true).count)
    where('published = ? and job_title IS NOT NULL', true).offset(offset).first
  end

  scope :with_published_questions, -> { joins(:questions).where(questions: { published: true }) }
  scope :published, -> { where(users: { published: true }) }
  scope :smart_order, -> { group('users.id, questions.user_id').order('count(questions.id) DESC, users.id DESC') }
  scope :active_ordered, -> { published.with_published_questions.smart_order }

  scope :paged, -> (options) do
    options = { nb_per_page: 12, page: 0 }.merge(options)
    limit(options[:nb_per_page]).offset(options[:nb_per_page] * options[:page])
  end


  def self.find_published_with_tag(options = {})
    options = { nb_per_page: 12, page: 0 }.merge(options)

    User.joins(:keywords)
        .where('users.published = ? and users.job_title IS NOT NULL AND keywords.tag = ?', true, options[:tag])
        .select('distinct users.*')
        .limit(options[:nb_per_page])
        .offset(options[:nb_per_page] * options[:page])
        .order(updated_at: :desc)
  end

  def has_explained_its_works?
    #complicated stuff to test an include
    identifiers = questions.map(&:identifier)
    Question::MY_WORK_QUESTIONS_IDENTIFIERS.all?{ |my_work_id| identifiers.include?(my_work_id) }
  end

  def last_month_view_count
    impressionist_count(
      start_date: Date.today.beginning_of_month.last_month,
      end_date: Date.today.beginning_of_month)
  end

  # returns default tribes order based on keywords
  def default_tribes
    hash = keywords.map(&:tribe).inject(Hash.new(0)) { |h, tribe| h[tribe] += 1; h }
    hash.delete(nil)
    hash.to_a.sort_by { |e| e[1] }.reverse.map { |e| e[0] }
  end

  def to_param
    { normalized_job_title: normalized_job_title,
      normalized_first_name: normalized_first_name }
  end

  private

  def normalize_job_title
    self.normalized_job_title = job_title.nil? ? '' : ActiveSupport::Inflector.parameterize(job_title)
  end

  def normalize_first_name
    return unless normalized_first_name.nil? || changed.include?('job_title')
    first_try = first_name.nil? ? '' : ActiveSupport::Inflector.parameterize(first_name)

    normalized_first_names =
      User.where(normalized_job_title: normalized_job_title)
          .where('normalized_first_name LIKE ?', "%#{first_try}")
          .pluck(:normalized_first_name)

    if normalized_first_names.count == 0
      self.normalized_first_name = first_try
    else
      index = normalized_first_names.map(&:to_i).sort.last + 1
      self.normalized_first_name = index.to_s + '-' + first_try
    end
  end

  def sync_with_intercom
    Intercom::Wrapper.create_or_update_user(self)
  end

  def check_published
    self.published = false unless self.questions.where(identifier: 'love_job', published: true).exists?
    true
  end

  def clean_first_name_and_job_title
    self.first_name = first_name.strip.mb_chars.capitalize.to_s unless first_name.nil?
    unless job_title.nil?
      self.job_title = job_title.strip
      self.job_title[0] = job_title[0].capitalize
    end
  end
end
