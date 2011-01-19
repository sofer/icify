class BrandsController < ApplicationController

  def index
    @brands = company.brands
    respond_to do |format|
      format.html 
    end
  end
  
  private
  
  def company
    @company ||= Company.find(params[:company_id])
  end

end
