class PortraitsController < ApplicationController
  def show
    @portrait = User.published
                    .includes(:tribes)
                    .includes(:questions)
                    .merge(Question.published)
                    .find(params[:id])

    impressionist(@portrait)
    @popular_keywords = Keyword.popular_keywords
  end

  def next
    redirect_to action: 'show', id: (User.next params[:id].to_i).id
  end

  def previous
    redirect_to action: 'show', id: (User.previous params[:id].to_i).id
  end

  def aleatoire
    redirect_to action: 'show', id: User.random.id
  end
end
