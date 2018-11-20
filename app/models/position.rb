class Position < ApplicationRecord
  validates :symbol, presence: true, length: { in: 1..5 }
  validates :num_shares,
     presence: true, 
     numericality: {
      only_integer: true,
      greater_than: 0
    }
end
