class ApplicationMailer < ActionMailer::Base
  address = Mail::Address.new 'alfred@bloomr.org'
  address.display_name = 'Alfred de Bloomr'
  default from: address.format
  layout 'mailer'
end
