# encoding: utf-8
require 'dm-is-authenticatable'

class User
  include DataMapper::Resource
  include DataMapper::Helpers::General
  
  property :id,           Serial
  property :login,        String, :messages => {
    :presence  => "You need to choose a login name",
    :is_unique => "Somebody has already registered using that login name",
    :length    => "Your login name needs to be between 6 and 20 characters long"
  }
  property :email,        String, :format => :email_address, :messages => { 
    :presence  => "You need to provide your email address", 
    :is_unique => "Somebody has already registered using that email address", 
    :format    => "That doesn't look like an email address"
  }
  property :displayname,  String
  property :admin,        Boolean, :default => false
  property :subscriber,   Boolean, :default => false

  validates_uniqueness_of :login, :email
  validates_presence_of   :login, :email
  validates_length_of     :login, :within => 6..20
  
  is :authenticatable
  
  FIELDS = [
    {:element => :input, :type => :text, :name => "email", :label => "Email address", :spellcheck => false},
    {:element => :input, :type => :text, :name => "login", :label => "Login name", :spellcheck => false},
    {:element => :input, :type => :password, :name => "password", :label => "Password"},
    {:element => :input, :type => :password, :name => "password_confirmation", :label => "Password confirmation"},
    {:element => :input, :type => :text, :name => "displayname", :label => "Display name"}
  ]
  
  def self.registration_fields
    FIELDS
  end
  
  # this is by definition an invalid user...
  def registration_fields
    fields = []
    self.valid?
    
    FIELDS.each do |field|      
      unless field[:name] == "password" || field[:name] == "password_confirmation"
        fields << filter_nil!(field.merge :value => self[field[:name]], :error => self.errors[field[:name].to_sym].first)        
      else
        fields << field
      end
    end
    fields
  end
end