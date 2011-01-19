class CollectionsController < ApplicationController
  
  def index
    @collections = company.collections
    respond_to do |format|
      format.html 
    end
  end
  
  private
  
  def company
    @company ||= Company.find(params[:company_id])
  end
  
end
