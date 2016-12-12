class JobsController < ApplicationController
  def index
    @bloomeurs = User.where(published: true).order(created_at: :desc).limit(12)
    @tribes = Tribe.all
    @bloomeur_of_month =
      User
      .where(published: true)
      .joins(:books).group('users.id').having('count(books.id)> ?', 2)
      .order(created_at: :desc).first
    @popular_keywords = Keyword.popular_keywords
  end

  def show
    find_h = { normalized_job_title: params[:normalized_job_title],
               normalized_first_name: params[:normalized_first_name] }

    @portrait = User.published
                    .includes(:tribes)
                    .includes(:questions)
                    .merge(Question.published)
                    .find_by(find_h)

    impressionist(@portrait)
    @popular_keywords = Keyword.popular_keywords
  end

  def show_by_id
    user = User.find(params[:id])
    redirect_to job_vanity_path(user.to_param)
  end
end
