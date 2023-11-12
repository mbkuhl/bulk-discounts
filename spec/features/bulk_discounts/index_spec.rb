require "rails_helper"

describe "merchant bulk discounts index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @bulk_discount1 = @merchant1.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 20)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 30)
    @bulk_discount3 = @merchant2.bulk_discounts.create!(quantity_threshold: 11, percentage_discount: 35)
  end

  describe "As a merchant When I visit my merchant dashboard" do
    describe "Then I see a link to view all my discounts When I click this link Then I am taken to my bulk discounts index page" do
      it "Where I see all of my bulk discounts including their percentage discount and quantity thresholds And each bulk discount listed includes a link to its show page" do
        visit "/merchants/#{@merchant1.id}/dashboard"
        click_link "Bulk Discounts"
        expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")
        expect(page).to have_content("Hair Care's Bulk Discounts:")
        expect(page).to have_content("Quantity Threshold: 5")
        expect(page).to have_content("Quantity Threshold: 10")
        expect(page).to_not have_content("Quantity Threshold: 11")
        expect(page).to have_content("Percentage Discount: 20")
        expect(page).to have_content("Percentage Discount: 30")
        expect(page).to_not have_content("Percentage Discount: 35")
      end
    end
  end

end