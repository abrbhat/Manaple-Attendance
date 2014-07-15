class AdminMailer < ActionMailer::Base
  default from: "no-reply@manaple.com"

  def notification()
  	mail to: ["bhatnagarabhiroop@gmail.com","peeyushagarwal1994@gmail.com"], subject: "Notification Email"
  end
end
