class SubscribeMailer < ApplicationMailer
  default from: 'Clubloot.com <clublootcom@gmail.com>'

  def subscribe_email(subscriber)
    @subscriber = subscriber

    mail(to: @subscriber.email, subject: 'Welcome to Clubloot.com')
  end
end
