require "rails_helper"

describe "merchant bulk discounts edit" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 20)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 30)
  end

  describe "As a merchant When I visit my bulk discount show page Then I see a link to edit the bulk discount
            When I click this link Then I am taken to a new page with a form to edit the discount" do
    it "And I see that the discounts current attributes are pre-poluated in the form When I change any/all of the information and click submit
        Then I am redirected to the bulk discount's show pageAnd I see that the discount's attributes have been updated" do
      visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}"
      click_link("Edit Bulk Discount #{@bulk_discount1.id}")
      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}/edit")
      expect(page).to have_content("Bulk Discount #{@bulk_discount1.id}")
      expect(find_field("Quantity threshold").value).to eq("5")
      expect(find_field("Percentage discount").value).to eq("20")

      fill_in "Quantity threshold", with: "6"
      fill_in "Percentage discount", with: "21"

      click_button "Submit"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}")
      expect(page).to_not have_content("Quantity Threshold: 5")
      expect(page).to_not have_content("Percentage Discount: 20")
      expect(page).to have_content("Quantity Threshold: 6")
      expect(page).to have_content("Percentage Discount: 21")

    end

    it "When I try to update a bulk discount with a pernding invoice item, it does not update, and I'm told why" do
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

      visit "/merchants/#{merchant1.id}/bulk_discounts/#{bulk_discount1.id}"
      click_link("Edit Bulk Discount #{bulk_discount1.id}")
      expect(page).to_not have_content("Bulk Discount #{bulk_discount1.id} has pending invoices and cannot be edited")
      expect(find_field("Quantity threshold").value).to eq("5")
      expect(find_field("Percentage discount").value).to eq("10")

      fill_in "Quantity threshold", with: "6"
      fill_in "Percentage discount", with: "21"

      click_button "Submit"

      expect(current_path).to eq("/merchants/#{merchant1.id}/bulk_discounts/#{bulk_discount1.id}")
      expect(page).to have_content("Quantity Threshold: 5")
      expect(page).to have_content("Percentage Discount: 10")
      expect(page).to have_content("Bulk Discount #{bulk_discount1.id} has pending invoices and cannot be edited")
      expect(page).to_not have_content("Quantity Threshold: 6")
      expect(page).to_not have_content("Percentage Discount: 21")
    end
  end
end

 