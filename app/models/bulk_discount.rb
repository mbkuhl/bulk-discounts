class BulkDiscount < ApplicationRecord
  validates_presence_of :quantity_threshold,
                        :percentage_discount
                        
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :ITEMS
end