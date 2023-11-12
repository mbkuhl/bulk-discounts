class AddMerchantToBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    add_reference :bulk_discounts, :merchant, foreign_key: true

  end
end
