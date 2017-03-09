class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  enum :type, [:plus, :minus]
  field :action,      type: String
  field :description, type: String
  field :from,        type: String
  field :to,          type: String
  field :unit,        type: String
  field :amount,      type: Float
  field :tax,         type: Float
  field :ref,         type: Hash, default: { format: '', id: '' }
  embedded_in :ledger

  def plus
    if self.type.present?
      self.type == :plus
    else
      self.action == 'plus'
    end
  end
end

