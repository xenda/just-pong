require 'bundler'

Bundler.setup
Bundler.require(:default)
Bundler.require(:development) if development?

get "/" do
  haml :index
end