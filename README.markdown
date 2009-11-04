# Active Scaffold Presentation

## First Phase

In this phase we'll create a simple scaffold with a single field.

1. Connect to working directory:
        cd Workspaces

2. Create a new Rails project:
        sudo rails camur
        chown -R medined:medined camur

3. Connect to project directory:
        cd camur

4. copy plugin:
        cp -R ~/support/render_component vendor/plugins
        cp -R ~/support/active_scaffold vendor/plugins

5. Create Person model:
        script/generate model person name:string

6. Execute the migration:
        rake db:migrate

7. Create the Person controller:
        script/generate controller person

8. Create app/controllers/person_controller.rb:
        class PersonController < ApplicationController
          layout 'default'
          active_scaffold :person
        end

9. Create a default layout:
        cp ../camur_backup/app/views/layouts/default.erb app/views/layouts

        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
          <meta http-equiv="Content-Type" content="text/html;.  charset=iso-8859-1" />
          <meta http-equiv="Content-Language" content="en-us" />
          <title>Presentation</title>
          <%= stylesheet_link_tag "style" %>
          <%= javascript_include_tag :defaults %>
          <%= active_scaffold_includes %>
        </head>
        <body id="page">
          <div id="container">
          <div id="header">
            <h1>CAMUR</h1>
          </div>
          <div id="content">
            <%= yield -%>
          </div>
          <div id="sidebar"></div>
          </div>
        </body>
        </html>

10. Start a server in a new terminal.
        script/server

11. Visit person page.
        http://localhost:3000/person

12, Review the show create, edit, show, search, delete options.

## Second Phase 

This phase of the project will use nearly all of the datatypes that 
ActiveScaffold supports. 

1. Create a Book model (all datatypes except for binary)
  script/generate model book person_id:integer name:string pages:integer price:float invoiced_at:datetime purchased_on:date paid_at:timestamp checkin:time description:text paperback:boolean

2. Create a controller for Book.
  script/generate controller book

3. Update the database.
  rake db:migrate

4. Edit app/models/book.rb to add relation to person.
  belongs_to :person

5. edit app/models/person.rb to add relation to books.
  has_many :books

6. Create app/controllers/book_controller.rb
  class BookController < ApplicationController
    layout 'default'
    active_scaffold :book
  end

7. start a server in a new terminal unless it is running
  script/server

8. visit book page.
  http://localhost:3000/book

9. Create and edit a book. You'll see too many fields and the order is uncontrolled.
The 'person' field should be titled 'Owners'.

10. Edit app/controllers/book_controller.rb to hide some of the book fields and rename 'person' to 'Owner'.
    active_scaffold :book do |config|
      config.create.columns = [ :name, :paperback, :price ]
      config.columns[:person].label = "Owner" 
    end

11. Reload the book page. Notice the server does not need to be restarted.
Check out the column sorting.

12. Create some books. Normally, I'd create a rake task to initialize test data.
Assign two books to David.

13. Visit the person page. Notice that the books show as a comma-delimited list.
Click on the list and you'll see the sub-form pop open.

    http://localhost:3000/person


14. The field order is not good. Edit app/controllers/person_controller.rb to fix this.
We'll change the date format later. 
    class PersonController < ApplicationController
      layout 'default'
      active_scaffold :person do |config|
        config.list.columns = [ :name, :books, :updated_at ]
      end
    end

15. Click edit. Notice the option to select an existing book or 
enter a new one. And that the person form
has only a name field, all the other fields are book fields.

16. Edit app/controllers/person_controller.rb to restrict user to only existing books. Note the plural needs to be used.
        active_scaffold :person do |config|
          config.columns[:books].form_ui = :select
        end

17. Reload person page. Edit a person. Associate books to person. Since
a book belongs_to a person, once it has been assigned it can't be 
assigned to another person.

18. Click on books link, show subform. 

19. Too many fields in subform. Edit app/controllers/book_controller.rb to restrict the list fields.
        active_scaffold :book do |config|
          config.list.columns = [ :name, :description, :paperback, :price, :updated_at ]
        end

20. Reload and click on books link. Notice fewer columns.

21. Let's prevent book deletion. Edit app/controllers/book_controller.rb
        def delete_authorized?
          false
        end

22. Reload and click on books link. Notice the delete link is gone.

## Third Phase

Time to fix the problem of ugly dates. There are several options
but we'll add a new function to the ActiveSupport::TimeWithZone class.

1. Edit app/controllers/application.rb.
    class ActiveSupport::TimeWithZone
      def format_short_date
        self.strftime("%m/%d/%Y")
      end
    end

2. Create a app/helpers/person_helpers.rb file. 
  module PersonHelper
    def updated_at_column(record)
      if record.updated_at.respond_to? :format_short_date
        record.updated_at.format_short_date
      else
        record.updated_at
      end
     end
  end

3. Edit app/helpers/person_helpers.rb by changing module to class to 
demonstrate an error.

4. Visit both the Person and Books pages to show that the helper module
is loaded for both controllers.

5. Edit app/controllers/application.rb to comment out the 'helper :all' line.

6. Reload the Books page to see that the helper module is no longer loaded. 

7. Edit app/controllers/PersonController.rb to add the following line after
the layout is defined.

  helper :person

8. Now the updated_at field on the Person page is different from the Book page. 

## Fourth Phase

1. Install the CalendarDateSelect gem.
        sudo gem install calendar_date_select

2. Add the following line immediately before the last end in config/environmnet.rb
        config.gem "calendar_date_select"

3. Restart the server.

4. Edit app/views/layouts/default.erb. Add the following line before the closing HEAD tag.
        <%= calendar_date_select_includes "silver" %>

5, Load the Book page. Click edit and look at the InvoicedAt field.

## Fifth Phase


!!!!!!!!!!!!!!!! Create a custom scaffold of Paperback books.


git push origin master
