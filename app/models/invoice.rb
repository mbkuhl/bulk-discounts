class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    invoice_items.sum { |ii| ii.discounted_revenue }.to_i
  end

  # def discounted_revenue
  #   results = ActiveRecord::Base.connection.execute("select invoices.id, sum(invoice_items.unit_price * invoice_items.quantity * (1 - (dt.max_discount/100))) as discounted_price from invoices
  #   inner join invoice_items on invoice_items.invoice_id = invoices.id
  #   inner join
  #   (select invoice_items.id as iiid, coalesce(max(bulk_discounts.percentage_discount), 0) as max_discount from invoice_items
  #   inner join items on items.id = invoice_items.id
  #   inner join merchants on merchants.id = items.merchant_id
  #   left join bulk_discounts on merchants.id = bulk_discounts.merchant_id
  #   group by invoice_items.id) dt on dt.iiid = invoice_items.id
  #   where invoices.id = #{id}
  #     group by invoices.id
  #           order by discounted_price desc")
  #           require 'pry'; binding.pry
  # end
end
