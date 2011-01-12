class ImportsController < ApplicationController

  def new
    @import = Import.new
    
    respond_to do |format|
      format.html
    end
  end

  def create
    @import = Import.new(params[:import])
    respond_to do |format|
      if @import.save
        format.html { redirect_to(@import.company, :notice => "#{@import.products.size} products were successfully imported.") }
      else
        flash[:alert] = "Did not save"
        format.html { render :action => "new" }
      end
    end
  end

  private 
  
  # needed?
  def company
    @company ||= Company.find(params[:company_id])
  end
  
end
