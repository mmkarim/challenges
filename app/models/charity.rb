class Charity < ActiveRecord::Base
  validates :name, presence: true

  MINIMUM_TOTAL_AMOUNT = 20.00
  PRECISION_LIMIT = 2

  def credit_amount(amount)
    self.with_lock do
      new_total = total + amount
      update_attribute :total, new_total
    end
  end
end
