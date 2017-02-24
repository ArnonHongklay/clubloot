class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  enum :action, [:plus, :minus]
  field :description, type: String
  field :from,        type: String
  field :to,          type: String
  field :unit,        type: String
  field :amount,      type: Float
  field :tax,         type: Float
  field :ref,         type: Hash, default: { format: '', id: '' }
  embedded_in :ledger
end

