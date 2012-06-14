# encoding:utf-8
require 'sinatra'
require 'erb'
require 'omniauth'
require 'omniauth-facebook'
require 'fb_graph'

enable :sessions

use OmniAuth::Builder do
  provider :facebook, ENV['APP_ID'], ENV['APP_SECRET'], :scope => "email,publish_stream"
end


get '/auth/facebook/callback' do
  @auth = request.env['omniauth.auth']
  access_token = @auth[:credentials][:token]
  user = FbGraph::User.me(access_token)
  user = user.fetch
  friends = user.friends
  @partner = friends[rand(friends.length)]
  @partner = @partner.fetch
  session[:token] = access_token
  if @partner.gender == user.gender
    @partner = nil
    session[:partner_name] = nil
  else
    session[:partner_name] = @partner.name
    session[:partner_link] = @partner.link
  end
  erb :callback
end

get '/' do
  erb :index
end

post '/share' do
  me = FbGraph::User.me(session[:token])
  begin
    if session[:partner_name]
      me.feed!(
      :message => '私の来世のパートナーはこの人でした！',
      #:picture => 'https://graph.facebook.com/matake/picture',
      :link => session[:partner_link],
      #:link => 'https://github.com/nov/fb_graph',
      :name => session[:partner_name],
      :description => session[:partner_name]
      )
    else
       me.feed!(
       :message => '私は来世でパートナーがいないみたいです。',
       )
    end
  rescue => e
    puts e.message
  end
  redirect '/result'
end

get '/result' do
  erb :result
end