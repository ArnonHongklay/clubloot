class Economy
  include Mongoid::Document
  include Mongoid::Timestamps

  field :kind,      type: String
  field :value,     type: Float, default: 0
  field :ledger_id, type: String
  field :logged_at, type: DateTime
end
