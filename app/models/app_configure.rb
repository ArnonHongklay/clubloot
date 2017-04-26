class AppConfigure
  include Mongoid::Document
  field :ruby, type: Hash
  field :sapphire, type: Hash
  field :emerald, type: Hash
  field :diamond, type: Hash

  field :daily_loot, type: Integer
  field :min_consecutive, type: Integer
  field :max_consecutive, type: Integer
  field :more_coin, type: Integer

  def self.exchange(user, type)
    gemc = first

    case type
    when 'sapphire'
      raise "coins or ruby less" if user.coins < gemc.ruby[:fee].to_i or user.rubies < gemc.ruby[:rate].to_i
      user.coins     = user.coins - gemc.sapphire[:fee].to_i
      user.rubies    = user.rubies - gemc.ruby[:rate].to_i
      user.sapphires = user.sapphires + 1

      from = 'rubies'
      to = 'sapphires'
    when 'emerald'
      raise "coins or sapphire less" if user.coins < gemc.sapphire[:fee].to_i or user.sapphires < gemc.sapphire[:rate].to_i
      user.coins     = user.coins - gemc.emerald[:fee].to_i
      user.sapphires = user.sapphires - gemc.sapphire[:rate].to_i
      user.emeralds  = user.emeralds + 1

      from = 'sapphires'
      to = 'emeralds'
    when 'diamond'
      raise "coins or emerald less" if user.coins < gemc.emerald[:fee].to_i or user.emeralds < gemc.emerald[:rate].to_i
      user.coins     = user.coins - gemc.diamond[:fee].to_i
      user.emeralds  = user.emeralds - gemc.emerald[:rate].to_i
      user.diamonds  = user.diamonds + 1

      from = 'emeralds'
      to = 'diamonds'
    end

    user.save!


    transactions = []
    transactions << OpenStruct.new(
      status: 'complete',
      format: 'Convert Gem',
      action: 'minus',
      description: 'Convert Gem',
      from: 'coins',
      to: to,
      unit: to,
      amount: 0,
      tax: 0
    )
    transactions << OpenStruct.new(
      status: 'complete',
      format: 'Convert Gem',
      action: 'minus',
      description: 'Convert Gem',
      from: from,
      to: to,
      unit: from,
      amount: 0,
      tax: 0
    )
    transactions << OpenStruct.new(
      status: 'complete',
      format: 'Convert Gem',
      action: 'plus',
      description: 'Convert Gem',
      from: to,
      to: "#{from} & coins",
      unit: to,
      amount: 0,
      tax: 0
    )

    Ledger.create_transactions(user, transactions)
  end
end
