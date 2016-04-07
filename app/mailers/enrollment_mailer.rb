class EnrollmentMailer < ApplicationMailer

  def enroll_email(email)
    mail(to: email, subject: 'Témoigner sur Bloomr')
  end
end
