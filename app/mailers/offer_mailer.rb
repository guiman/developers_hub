class OfferMailer < ApplicationMailer
  default from: "alvaro@dev-hub.io"

  def new_offer(developer, body)
    @developer = developer
    @body = body

    mail to: @developer.developer.email, subject: "Job offer", reply_to: @developer.viewer.email
  end
end
