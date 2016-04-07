class EnrollmentMailer < ApplicationMailer

  def enroll_email(user_hash)
    @typeform_link = "https://bloomr.typeform.com/to/FIuafU?email=#{ user_hash['email'] }&metier=#{ user_hash['job_title'] }&prenom=#{ user_hash['first_name'] }"
    mail(to: user_hash['email'], subject: 'Témoigner sur Bloomr')
  end
end
