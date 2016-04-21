class UserRecallMailer < ApplicationMailer

  def recall_email(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: 'On vous l’avait promis, Bloomr grandit !', from: 'stephanie@bloomr.org')
  end

end
