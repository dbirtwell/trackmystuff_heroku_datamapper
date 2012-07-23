# trackmystuff

A simple CRUD application using datamapper in Sinatra. 
It was created as a learning project and is not expected to be beautiful by amy means

This is the version I pushed to Heroku initially. Others will follow.

This version uses erb and future versions will use haml, as well as ActiveRecord.
Tests will be present in future versions. This is just the beginning!

Added "Name" Validation:

  Added error view.
  Used sinatra/flash to preserve DataMapper server-side errors to be used to display an error message on the error view page.

Added Pagination:

  required subclassing Sinatra::Base

Added code to preserve put and update/delete code:

  use Rack::MethodOverride

  http://www.humbug.in/docs/sinatra-book/the-put-and-delete-methods.html

  http://www.sinatrarb.com/configuration.html

  :method_override - enable/disable the POST _method hack

  Boolean specifying whether the HTTP POST _method parameter hack should be enabled. When true, the actual HTTP request method is overridden by the value of the _method parameter included in the POST body. The _method hack is used to make POST requests look like other request methods (e.g., PUT, DELETE) and is typically only needed in shitty environments – like HTML form submission – that do not support the full range of HTTP methods.

  The POST _method hack is implemented by inserting the Rack::MethodOverride component into the middleware pipeline.
  
Added Rake task to seed database

