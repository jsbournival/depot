class StoreController < ApplicationController
  def index
  	@products = Product.order(:title)
  	session[:counter] = session[:counter].nil? ? 1 : session[:counter]+1
  end
end
