# trackmystuff.rb
#
# A simple Sinatra CRUD application to track various items an individual might
# own.
#
# This is done as a personal learning exercise and not meant as a commercial-
# grade application.
#
# No warranty or support is provided for this application by the author.
# Author is not responsible for any damage to hardware or software.
#
require 'rubygems'
## require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.
require 'sinatra/flash'
require 'sinatra/base'
require 'sinatra/paginate'

# For pagination results
Struct.new('Result', :total, :size, :list_items)

# define a simple model
class Items
  include DataMapper::Resource

  property :id, Serial
  property :name, String,  :required => true
  property :item_type, String
  property :item_location_1, String
  property :item_location_2, String  
  property :description, Text
  property :created_at, DateTime , :default => Time.now
end


class App < Sinatra::Base

  register Sinatra::Paginate
  register Sinatra::Flash
  
  # Required based upon the below:
  # http://www.humbug.in/docs/sinatra-book/the-put-and-delete-methods.html
  use Rack::MethodOverride

  enable :sessions

  configure do
    # Heroku has some valuable information in the environment variables.
    # DATABASE_URL is a complete URL for the Postgres database that Heroku
    # provides for you, something like: postgres://user:password@host/db, which
    # is what DM wants. This is also a convenient check wether we're in production
    # / not.
  
    # puts "ENV for DATABASE_URL:"
    # puts ENV['DATABASE_URL']
    # puts "SHARED_DATABASE_URL:"
    # puts ENV['SHARED_DATABASE_URL']
  
    puts "GET DB Connection"

    DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
    # DataMapper.setup(:default, (ENV["SHARED_DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))  
    DataMapper.auto_upgrade!
  
    puts "DONE DB Connection"  
  end


  # Perform basic sanity checks and initialize all relationships
  # Call this when you've defined all your models
  DataMapper.finalize

  # automatically create the items table
  Items.auto_upgrade!

#  not_found do
#    status 404
#    'Sorry. The page you requested is not found.'
#  end

  helpers do
    def page
      [params[:page].to_i - 1, 0].max
    end
  end

  # Home - list all items
  get '/' do
    begin

      # @list_items = Items.all    
      @list_items  = Items.all(limit: 10, offset: page * 10)
      @result = Struct::Result.new(Items.count, @list_items.count, @list_items)
      erb :index
    rescue => ex
      'Cannot generate items list'
      "#{ex.class}: #{ex.message}"
    end
  end

  # Create new item (form)
  get '/new' do
    begin
      erb :new
    rescue => ex
      'Cannot generate items list'
      "#{ex.class}: #{ex.message}"
    end
  end

  # Save item info
  post '/' do
    begin
  
      # DEBUG
      ## display all params
      #params.values.each do |v|
      #  puts "#{v}"
      #end
  
      @item = Items.create(:name => params[:name], :item_type => params[:item_type], :item_location_1 => params[:item_location_1], :item_location_2 => params[:item_location_2], :description => params[:description])
    
      if (@item.save)
        redirect "/#{@item.id}"
        
#
# TODO: Sinatra Flash doesn't seem to work any longer
#
      else
    
        # TODO: Eventiually, we might handle more than one error
        # @item.errors.each do |e|
        #  puts e
        # end 
        flash[:error] = "* Name: #{@item.name} #{@item.errors.on(:name)}"
        puts "Name: #{@item.name} #{@item.errors.on(:name)}"
      
        redirect "/error"    
      end
    rescue
      redirect '/'
    end
  end

  get '/error' do
    erb :error
  end

  # Display item's details
  get '/:id' do
    begin
      @item = Items.get(params[:id])
      erb :show
    rescue
      redirect '/'
    end
  end

  # Delete item
  get '/delete/:id' do
    puts 'delete step 1'
    @item = Items.get(params[:id])
    erb :delete
  end

  delete '/:id' do
    puts 'delete step 2'  
    item = Items.get(params[:id])
    puts 'delete step 3'      
    item.destroy
    puts 'delete step 4'      
    redirect '/'
  end

  # Update item
  get '/edit/:id' do
    @item = Items.get(params[:id])
    erb :edit
  end

  put '/:id' do
    item = Items.get(params[:id])
    item.name = params[:name]
    item.item_type = params[:item_type]
    item.item_location_1 = params[:item_location_1]
    item.item_location_2 = params[:item_location_2]
    item.description = params[:description]  
    item.save
    redirect '/'
  end

# End Sinatra::Base extend
end