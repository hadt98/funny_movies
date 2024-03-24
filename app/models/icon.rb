class Icon < ApplicationRecord
  validates :symbol, presence: true
  validates :code, presence: true

end
