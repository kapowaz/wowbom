# encoding: utf-8
require 'dm-is-authenticatable'

class User
  include DataMapper::Resource
  include DataMapper::Helpers::General
  
  property :id,           Serial
  property :login,        String, :messages => {
    :length => "Your login name needs to be between 6 and 20 characters long"
  }
  property :email,        String, :format => :email_address, :messages => { 
    :format => "That doesn't look like an email address"
  }
  property :displayname,  String
  property :admin,        Boolean, :default => false
  property :subscriber,   Boolean, :default => false

  validates_uniqueness_of   :login,                 :message => "Somebody has already registered using that login name"
  validates_presence_of     :login,                 :message => "You need to choose a login name"
  validates_uniqueness_of   :email,                 :message => "Somebody has already registered using that email address"
  validates_presence_of     :email,                 :message => "You need to provide your email address"
  validates_length_of       :login,                 :within  => 6..20
  validates_presence_of     :password,              :message => "You need to enter a password"
  validates_presence_of     :password_confirmation, :message => "You need to confirm your password by typing it again here"
  validates_confirmation_of :password,              :message => "Password and confirmation need to be the same"

  is :authenticatable
  
  FIELDS = [
    {:element => :input, :type => :text, :name => "email", :label => "Email address", :spellcheck => false, :required => true},
    {:element => :input, :type => :text, :name => "login", :label => "Login name", :spellcheck => false, :required => true},
    {:element => :input, :type => :password, :name => "password", :label => "Password", :required => true},
    {:element => :input, :type => :password, :name => "password_confirmation", :label => "Confirm your password", :required => true}
  ]
  
  def self.registration_fields
    FIELDS
  end
  
  # this is implicitly an invalid user...
  def registration_fields
    fields = []
    FIELDS.each do |field|
      case field[:name]
      when "password"
        fields << field.merge(:error => self.errors[:password].first)
      when "password_confirmation"
        fields << field.merge(:error => self.errors[:password_confirmation].first)
      else
        fields << field.merge(filter_nil! :value => self[field[:name]], :error => self.errors[field[:name].to_sym].first, :valid => (self.errors[field[:name].to_sym].empty? ? true : nil))
      end
    end
    fields
  end
end