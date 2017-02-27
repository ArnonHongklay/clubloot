class Ledger
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status,      type: String
  field :format,      type: String

  field :user,    type: Hash, default: lambda { default_users }
  field :balance, type: Hash, default: lambda { default_balance }
  field :details, type: Hash, default: lambda { default_details }
  embeds_many :transactions

  private
    def default_users
      {
        id: '',
        username: '',
        name: '',
        email: ''
      }
    end

    def default_balance
      {
        coins: 0,
        diamonds: 0,
        emeralds: 0,
        sapphires: 0,
        rubies: 0
      }
    end

    def default_details
      {
        tracking_number: '',
        carrier: ''
      }
    end
end
