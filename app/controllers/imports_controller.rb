class ImportsController < ApplicationController

  def new
    @import = Import.new
    
    respond_to do |format|
      format.html
    end
  end

  def create
    if params[:import][:csv_file]
      @import = Import.new
      flash[:notice] = "imported data go here"
      
      @imported_file = params[:import][:csv_file]

      respond_to do |format|
        format.html { render :action => "new" }
        #format.html { render :text => params[:import][:csv_file].to_json }
      end

    else
      
      @import = Product.new(params[:product])

      # process all the import lines

      respond_to do |format|
        if @import.save
          format.html { redirect_to(@import, :notice => 'Product was successfully created.') }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

  private 
  
  def company
    @company ||= Company.find(params[:company_id])
  end
  
end
