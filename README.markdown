# Active Scaffold Presentation

## First Phase

In this phase we'll create a simple scaffold with a single field.

1. Connect to working directory:
        cd Workspaces

2. Create a new Rails project:
        rails camur

3. Connect to project directory:
        cd camur

4. copy plugin:
        cp -R ~/support/active_scaffold vendor/plugins

5. Create app/models/person.rb:
        class Person < ActiveRecord::Base
        end

6. Create a migration:
        script/generate migration create_people

7. Update migration to match the following:
        class CreatePeople < ActiveRecord::Migration
          def self.up
            create_table :people do |t|
              t.string :name
              t.timestamps
            end
          end
        
          def self.down
            drop_table :people
          end
        end

8. Execute the migration:
        rake db:migrate

9. Create app/controllers/person_controller.rb:
        class PersonController < ApplicationController
          layout 'default'
          active_scaffold :person
        end

10. Create a default layout:
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

11. Start a server in a new terminal.
        script/server

12. Visit person page.
        http://localhost:3000/person

13, Review the show create, edit, show, search, delete options.

## Second Phase 

This phase of the project will use nearly all of the datatypes that ActiveScaffold supports. 

1. Create a books model (all datatypes except for binary)
<script src='http://pastie.org/492160.js'></script>

2. Update the database.
        rake db:migrate

3. Edit app/models/book.rb to add relation to person.
        belongs_to :person

4. edit app/models/person.rb to add relation to books.
        has_many :books

5. Create app/controllers/book_controller.rb
        class BookController < ApplicationController
          layout 'default'
          active_scaffold :book
        end

6. start a server in a new terminal unless it is running
        script/server

7. visit book page.
        http://localhost:3000/book

8. Create and edit a book. You'll see too many fields and the order is uncontrolled.
The 'person' field should be titled 'Owners'.

12. Edit app/controllers/book_controller.rb to hide some of the book fields and rename 'person' to 'Owner'.
        active_scaffold :book do |config|
          config.create.columns = [ :name, :paperback, :price ]
          config.columns[:person].label = "Owner" 
        end

13. Reload the book page. Notice the server does not need to be restarted.

14. Create some books. Normally, I'd create a rake task to initialize test data.

15. Visit the person page.
        http://localhost:3000/person

16. The field order is not good. Edit app/controllers/person_controller.rb to fix this. 
        class PersonController < ApplicationController
          layout 'default'
          active_scaffold :person do |config|
            config.list.columns = [ :name, :books ]
          end
        end

17. Click edit. Notice the option to select an existing book or 
enter a new one. Notice that the person form
has only a name field, all the other fields are book fields.

18. Edit app/controllers/person_controller.rb to restrict user to only existing books. Note the plural needs to be used.
        active_scaffold :person do |config|
          config.columns[:books].form_ui = :select
        end

19. Reload person page. Edit a person. Associate books to person. Since
a book belongs_to a person, once it has been assigned it can't be 
assigned to another person.

20. Click on books link, show subform. 

21. Too many fields in subform. Edit app/controllers/book_controller.rb to restrict the list fields.
        active_scaffold :book do |config|
          config.list.columns = [ :name, :description, :paperback, :price ]
        end
22. Reload and click on books link. Notice fewer columns.

23. Let's prevent book deletion. Edit app/controllers/book_controller.rb
        def delete_authorized?
          false
        end

24. Reload and click on books link. Notice the delete link is gone.

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
        class PersonHelper
          def updated_at_column(record)
            if record.updated_at.respond_to? :format_short_date
              record.updated_at.format_short_date
            else
              record.updated_at
            end
          end
        end

Notice that books is also affected.

Change 'helper :all' in application.rb

Add 'helper PersonHelper' to PersonController.rb

!!!!!!!!!!!!!!!! Add Date Picker!!

!!!!!!!!!!!!!!!! Create a custom scaffold of Paperback books.

camur




Start the VM
-------------
virtualbox &

  USERID: as
  PASSWORD: password
  HOST KEY: RIGHT CONTROL


2009 Apr 02
  Installed Ruby and RubyGems
     # ruby
    cd ~/rn
    wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.1-p0.tar.gz
    tar -xzvf ruby-1.9.1-p0.tar.gz
    cd ~/rn/ruby-1.9.1-p0
    ./configure
    make
    make test
    sudo make install
    # zlib
    cd ~/rn/ruby-1.9.1-p0/ext/zlib
    sudo apt-get install zlib1g-dev
    ruby extconf.rb --with-zlib-include=/usr/include --with-zlib-lib=/usr/lib
    make
    sudo make install
    # gem
    cd ~/rn
    wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
    tar -xzvf rubygems-1.3.1.tgz
    cd rubygems-1.3.1
    sudo ruby setup.rb
    # fix ruby executable
    cd ~/rn/ruby-1.9.1-p0
    sudo make install

    rm ~/rn/ruby-1.9.1-p0.tar.gz
    rm ~/rn/rubygems-1.3.1.tgz


    # rails
    cd ~
    vi .bashrc
      PATH=$PATH:/home/as/.gem/ruby/1.9.1/bin
      export PATH
    source .bashrc
    gem install rails
    # git
    sudo apt-get install git-core

    # rspec
    gem install rspec
    gem install rspec-rails
    # mysql
    sudo apt-get install mysql-server-5.0
      PASSWORD: password
    # example application
    git clone git://github.com/activefx/restful_authentication_tutorial.git rat
    cd rat
    git submodule init
    git submodule update
    cp config/database.yml.example config/database.yml
    cp config/config.yml.example config/config.yml
    rake db:create:all or db:create
    rake db:migrate

  # Ruby Enterprise Edition
  cd ~/rn
  wget http://rubyforge.org/frs/download.php/51101/ruby-enterprise_1.8.6-20090201_i386.deb
  sudo dpkg -i ruby-enterprise_1.8.6-20090201_i386.deb
  rm ruby-enterprise_1.8.6-20090201_i386.deb
  vi ~/.bashrc
    PATH=$PATH:/opt/ruby-enterprise/bin
    export PATH
  sudo apt-get install build-essential
  sudo apt-get install apache2-mpm-prefork
  sudo apt-get install apache2-prefork-dev
  sudo -s
  /opt/ruby-enterprise/bin/passenger-install-apache2-module
  exit

    
  Cloned VM
    cd /home/medined/.VirtualBox/VDI
    vboxmanage clonevdi ubuntu_8_10.vdi ruby.vdi
  Updated VM.

2009 Apr 01
  Installed VirtualBox
  Downloaded Ubuntu 8.10 Desktop ISO file.


git push origin master
