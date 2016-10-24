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
end
