class JobsController < ApplicationController
  def index
    @bloomeurs = User.where(published: true).order(created_at: :desc).limit(11)
    @tribes = Tribe.all
    @bloomeur_of_month =
      User
      .joins('join challenges_users on challenges_users.user_id = users.id and challenges_users.challenge_id=2')
      .includes(:books)
      .first
    @popular_keywords = Keyword.popular_keywords
    render layout: 'new_home'
  end
end
