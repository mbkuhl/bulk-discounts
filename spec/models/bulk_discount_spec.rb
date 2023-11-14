require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :quantity_threshold }
    it { should validate_presence_of :percentage_discount }
  end

  describe "relationships" do
    it { should belong_to :merchant }
  end

  describe "instance methods" do
    it "has_pending_invoice_items?" do
      merchant1 = Merchant.create!(name: "Hair Care")
  
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant1.id)
      item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: merchant1.id)
      item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: merchant1.id)
      item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: merchant1.id)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)
  
      item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: merchant1.id)
      item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: merchant1.id)
  
      customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")

  
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

      
      invoice_6 = Invoice.create!(customer_id: customer_1.id, status: 2)
  
      invoice_8 = Invoice.create!(customer_id: customer_1.id, status: 1)
  
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 0) #nd - 90 d - 81
      ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 10, status: 2)
      ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 2, unit_price: 8, status: 2)
      ii_4 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 3, unit_price: 5, status: 1)
      ii_6 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_4.id, quantity: 1, unit_price: 1, status: 1)
      ii_8 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 1, unit_price: 5, status: 1) # nd - 5
      ii_9 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_4.id, quantity: 1, unit_price: 1, status: 1) # nd - 1
      ii_11 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 12, unit_price: 6, status: 1) #nd - 72 d - 54
  
      transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
      transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: invoice_1.id)
      transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: invoice_1.id)
      transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: invoice_1.id)
      transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: invoice_1.id)
      transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: invoice_1.id)
      transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
      transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
      bulk_discount1 = merchant1.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 10)
      bulk_discount2 = merchant1.bulk_discounts.create!(quantity_threshold: 12, percentage_discount: 25)
      expect(bulk_discount1.has_pending_invoice_items?).to be true
      expect(bulk_discount2.has_pending_invoice_items?).to be false
    end
  end
end