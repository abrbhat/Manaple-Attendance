class AsmMailer < ActionMailer::Base
  default from: "peeyushacads@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.thankyou.subject
  #
  def notification()

    mail to: "bhatnagarabhiroop@gmail.com", subject: "We are sending you a notification"
  end

end
