require "rails_helper"

describe "Merchant Bulk Discount New" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")
  end
  
  it "should be able to fill in a form and create a new merchant" do
    visit "/merchants/#{@m1.id}/bulk_discounts"
    expect(page).to_not have_content("Quantity Threshold: 10")
    expect(page).to_not have_content("Percentage Discount: 15")

    click_link("Create New Bulk Discount")

    expect(current_path).to eq("/merchants/#{@m1.id}/bulk_discounts/new")

    fill_in :quantity_threshold, with: "10"
    fill_in :percentage_discount, with: "15"

    click_button

    expect(current_path).to eq("/merchants/#{@m1.id}/bulk_discounts")
    expect(page).to have_content("Quantity Threshold: 10")
    expect(page).to have_content("Percentage Discount: 15")
  end
end