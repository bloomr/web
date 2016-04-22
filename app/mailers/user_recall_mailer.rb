class UserRecallMailer < ApplicationMailer

  def recall_email(user, password)
    @user = user
    @password = password
    address = Mail::Address.new 'stephanie@bloomr.org'
    address.display_name = 'Stephanie de Bloomr'
    mail(to: @user.email, subject: 'On vous l’avait promis, Bloomr grandit !', from: address.format)
  end

end
