class Ledger
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status,      type: String
  field :format,      type: String

  field :user,    type: Hash, default: lambda { default_users }
  field :balance, type: Hash, default: lambda { default_balance }
  field :details, type: Hash, default: lambda { default_details }
  embeds_many :transaction

  def self.create_transaction(user, transaction)
    ledgers = self.create(
      status: transaction.try(:status) || 'completed',
      format: transaction.try(:format),
      user: {
        'id': user._id,
        username: user.username,
        name: "#{user.first_name} #{user.last_name}",
        email: user.email
      },
      balance: {
        coins: user.coins,
        diamonds: user.diamonds,
        emeralds: user.emeralds,
        sapphires: user.sapphires,
        rubies: user.rubies
      }
    )

    ledgers.transaction.create(
      action: transaction.try(:action),
      description: transaction.try(:description),
      from: transaction.try(:from),
      to: transaction.try(:to),
      unit: transaction.try(:unit),
      amount: transaction.try(:amount),
      tax: transaction.try(:tax),
      ref: {
        format: nil,
        id: nil
      }
    )
  end

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
