# app.rb
require 'sinatra'

class HelloApp < Sinatra::Base
  get '/' do
    "Hello, Regalii! Is it me you're looking for?"
  end
end
