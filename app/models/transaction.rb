class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  # enum :type, [:plus, :minus]
  field :action,      type: String
  field :description, type: String
  field :from,        type: String
  field :to,          type: String
  field :unit,        type: String
  field :amount,      type: Float, default: 0
  field :tax,         type: Float, default: 0
  field :ref,         type: Hash, default: { format: '', id: '' }
  embedded_in :ledger

  # def plus
  #   if self.action.present?
  #     self.action == 'plus'
  #   # else
  #   #   self.type == :plus
  #   end
  # end
end
