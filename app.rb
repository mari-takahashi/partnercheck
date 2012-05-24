# myapp.rb
require 'sinatra'
require 'erb'
require 'omniauth'
require 'omniauth-facebook'

enable :sessions

use OmniAuth::Builder do
  provider :facebook, ENV['APP_ID'], ENV['APP_SECRET'], :scope => "email"
end

get '/auth/facebook/callback' do
  @auth = request.env['omniauth.auth']
  session[:name] = @auth[:info][:name]
  erb :callback
end


post '/res' do
  test = params[:hoge1].to_i + params[:hoge2].to_i
  
  if test > 10
    @a = "over 10"
  else
    @a = "small 10"
  end
  
  erb :result
end

get '/' do
  erb :index
end