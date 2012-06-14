class User < ActiveRecord::Base
  col :uid, :index => { :column => [:uid], :unique => true, :name => 'uid_on_users' }
  col :name
  col :image
  col :token
  col :secret
end
User.auto_upgrade!