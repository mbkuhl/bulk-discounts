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
      expect(find_field("Quantity Threshold").value).to eq("5")
      expect(find_field("Percentage Discount").value).to eq("20")

      fill_in "Quantity Threshold", with: "6"
      fill_in "Percentage Discount", with: "21"

      click_button "Submit"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}")
      expect(page).to_not have_content("Quantity Threshold: 5")
      expect(page).to_not have_content("Percentage Discount: 20")
      expect(page).to have_content("Quantity Threshold: 6")
      expect(page).to have_content("Percentage Discount: 21")

    end
  end
end

 