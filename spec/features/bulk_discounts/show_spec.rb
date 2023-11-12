require "rails_helper"

describe "merchant bulk discounts show" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 20)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 30)
    @bulk_discount3 = @merchant2.bulk_discounts.create!(quantity_threshold: 11, percentage_discount: 35)
  end

  describe "As a merchant, When I visit my bulk discount show page" do
    it "Then I see the bulk discount's quantity threshold and percentage discount" do
      visit merchant_bulk_discount_path(@merchant1, @bulk_discount1)
      expect(page).to have_content("Bulk Discount #{@bulk_discount1.id}")
      expect(page).to have_content("Quantity Threshold: 5")
      expect(page).to have_content("Percentage Discount: 20")
    end
  end
end
