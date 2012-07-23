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
require 'data_mapper' # metagem, requires common plugins too.

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

  
  puts "GET DB Connection"

  DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
  # DataMapper.setup(:default, (ENV["SHARED_DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))  
  DataMapper.auto_upgrade!
  
  puts "DONE DB Connection"  



# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the items table
Items.auto_upgrade!

30.times {|i| 
  puts "Seeding item #{i + 1}"
  @item = Items.create(:name => "Test Item number #{i+1}", 
  :item_type => "Item type number #{i+1}", 
  :item_location_1 => "Item location_1 number #{i+1}", 
  :item_location_2 => "item location_2 number #{i+1}", 
  :description => "Description Number #{i+1}")}

#  @item = Items.create(:name => "Test Item number 1", :item_type => "Item type number 2", :item_location_1 => "Item location_1 number 1", :item_location_2 => "item location_2 number 1", :description => "Description Number 1")
puts "Done seeding the DB"
