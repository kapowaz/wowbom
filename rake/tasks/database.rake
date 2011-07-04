require 'yaml'
require 'data_mapper'

namespace :db do
  desc "Create the database"
  task :create do
    config_file = "config/database.yml"
    if File.exists?(config_file)
      config = YAML.load(File.new(config_file))[:development]
      puts "Creating database '#{config[:database]}'"
      user, password, database = config[:username], config[:password], config[:database]
      args = ["--user=#{user}"]
      args << "--password=#{password}" if password
      args << "-e create database #{database}"
      system('mysql', *args)
    else
      puts "Config file '#{config_file}' doesn't exist."
    end
  end
  
  desc "Run database migrations"
  task :migrate do
    DataMapper.auto_migrate!
  end
end