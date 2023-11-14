class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    invoice_items.sum { |ii| ii.discounted_revenue }.to_i
  end

  # def discounted_revenue
  #   results = ActiveRecord::Base.connection.execute("select invoices.id as invoice_id, sum(invoice_items.unit_price * invoice_items.quantity * (1 - (dt.max_discount/100))) as discounted_price from invoices
	# inner join invoice_items on invoice_items.invoice_id = invoices.id
	# inner join
	# (select invoice_items.id as iiid, coalesce(max(case when invoice_items.quantity >= bulk_discounts.quantity_threshold then bulk_discounts.percentage_discount else 0 end), 0) as max_discount from invoice_items
	# 				inner join items on items.id = invoice_items.id
	# 				inner join merchants on merchants.id = items.merchant_id
	# 				left join bulk_discounts on merchants.id = bulk_discounts.merchant_id
	# 						group by invoice_items.id) as dt on dt.iiid = invoice_items.id
	# 			where invoices.id > 0
	# 				group by invoices.id
	# 					order by invoices.id")
  #           require 'pry'; binding.pry
  # end

  # def discounted_revenue
  #   invoice_items.sum("unit_price * quantity * (100 - #{InvoiceItem.find(self.invoice_items.first.id).item.merchant.bulk_discounts.max("percentage_discount")} / 100)" )
  # end
end
