class LandingController < ApplicationController
  layout 'landing'
  skip_before_action :verify_authenticity_token

  def index
  end

  def subscribes
    if subscriber = Subscribe.create(name: params[:name], email: params[:email])
      SubscribeMailer.subscribe_email(subscriber)
    end
  end
end
