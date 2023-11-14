class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = @bulk_discount.merchant # Added to make the topnav work so it's less annoying to click around
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    BulkDiscount.create!(bulk_discount_params)
    redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
  end
  
  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = @bulk_discount.merchant # Added to make the topnav work so it's less annoying to click around
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = @bulk_discount.merchant # Added to make the topnav work so it's less annoying to click around
    unless @bulk_discount.has_pending_invoice_items?
      @bulk_discount.update!(
        quantity_threshold: params[:bulk_discount][:quantity_threshold],
        percentage_discount: params[:bulk_discount][:percentage_discount]
      )
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/#{params[:id]}"
    else
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts/#{params[:id]}"
      flash.notice = "Bulk Discount #{@bulk_discount.id} has pending invoices and cannot be edited"
    end
  end

  def destroy
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = @bulk_discount.merchant # Added to make the topnav work so it's less annoying to click around
    unless @bulk_discount.has_pending_invoice_items?
      BulkDiscount.destroy(params[:id])
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
    else
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
      flash.notice = "Bulk Discount #{@bulk_discount.id} has pending invoices and cannot be deleted"
    end
  end

  private
  def bulk_discount_params
    params.permit(:quantity_threshold, :percentage_discount, :merchant_id)
  end
end