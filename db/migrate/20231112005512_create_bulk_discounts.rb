class CreateBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_discounts do |t|
      t.integer :quantity_threshold
      t.integer :percentage_discount
      t.timestamps
    end
  end
end
