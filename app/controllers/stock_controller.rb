class StockController < ApplicationController
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => stock }
    end
  end

  private
  
  def stock
    @company.to_json(:include => {:brands => {
      :only => [:id,:name,:title,:inventory,:sku], 
      :include => {:collections => {
        :include => { :products => {
          :include => :variants
        }}
      }}
    }})
  end

end
