class PersonController < ApplicationController
  layout 'default'
  helper PersonHelper 
  active_scaffold :person do |config|
    config.columns[:books].form_ui = :select
    config.list.columns = [ :name, :books, :updated_at ]
  end
end
