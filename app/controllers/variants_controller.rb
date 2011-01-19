class VariantsController < ApplicationController
  
  def index
    @variants = product.variants

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  private
  
  def product
    @product ||= Product.find(params[:product_id])
  end

end
