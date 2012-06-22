require 'sinatra'
require 'haml'
require 'coffee-script'
require "sinatra/reloader" if development?

get "/" do
  haml :index
end

get "/application.js" do
  coffee :application
end