# encoding: utf-8
require 'dm-is-authenticatable'

class User
  include DataMapper::Resource
  
  property :id,           Serial
  property :login,        String
  property :displayname,  String
  property :email,        String     

  is :authenticatable

  # soon™
  # has n, :characters

end