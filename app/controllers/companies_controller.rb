class CompaniesController < ApplicationController
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end
  
  def edit
    @company = Company.find(params[:id])    
  end

  def update
    @company = Company.find(params[:id])
    
    respond_to do |format|
      if @product.update_attributes(params[:company])
        format.html { redirect_to(@company, :notice => 'company was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end
  

end
