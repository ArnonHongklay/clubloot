# Preview all emails at http://localhost:3000/rails/mailers/subscribe_mailer
class SubscribeMailerPreview < ActionMailer::Preview

  def subscribe
    SubscribeMailer.subscribe_email(Subscribe.first)
  end
end
