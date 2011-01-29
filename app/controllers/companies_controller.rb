class CompaniesController < ApplicationController
  
  def index
    @companies = Company.all
    respond_to do |format|
      format.html
      format.json { render :json => @companies }
    end
  end
  
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => stock }
    end
  end
  
  def edit
    @company = Company.find(params[:id])    
  end

  def update
    @company = Company.find(params[:id])
    
    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to(@company, :notice => 'Stock was successfully updated.') }
        format.xml  { head :ok }
      else
        flash[:alert] = "Did not update"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def stock
    @company.to_json(:include => { :brands => { 
      :only => [:id,:name,:title,:inventory,:sku], 
        :include => {:products => { 
          :include => :variants 
        }}
    }})
  end

end
