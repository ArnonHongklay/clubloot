class Subscribe
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String

  after_create :send_email

  private
    def send_email
      SubscribeMailer.subscribe_email(self).deliver_now
    end
end
