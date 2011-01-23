class ImportsController < ApplicationController

  def index
    @imports = company.imports

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end
  
  def new
    @import = company.imports.new
    
    respond_to do |format|
      format.html
    end
  end

  def create
    @import = company.imports.new(params[:import])
    respond_to do |format|
      if @import.save
        format.html { redirect_to(@import, :notice => "#{@import.products.size} products were successfully imported.") }
      else
        flash[:alert] = "Did not save"
        format.html { render :action => "new" }
      end
    end
  end

  private 
  
  def company
    @company ||= Company.find(params[:company_id])
  end
  
end
