require 'sinatra/base'
require File.dirname(__FILE__) + '/../lib/sinatra/simple_auth'

class SinatraModularApp < Sinatra::Base
  enable :sessions
  register Sinatra::SimpleAuth

  set :username, 'username'
  set :password, 'password'
  set :home, '/'

  get '/' do
    "hello, i'm root"
  end

  get '/public' do
    if authorized?
      "hello, #{settings.username}"
    else
      "Please login"
    end  
  end

  get '/pvt' do
    protected!
    "private area"
  end
end