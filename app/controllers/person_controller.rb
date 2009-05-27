class PersonController < ApplicationController
  layout 'default'
  active_scaffold :person do |config|
    config.columns[:books].form_ui = :select
    config.list.columns = [ :name, :books ]
  end
end
