class BookController < ApplicationController
  layout 'default'
  active_scaffold :book do |config|
    config.create.columns = [ :name, :paperback, :price ]
    config.list.columns = [ :name, :description, :paperback, :price, :updated_at ]
    config.columns[:person].label = "Owner" 
  end
  
  def delete_authorized?
    false
  end
end
