require 'yaml'
require 'data_mapper'

namespace :db do
  desc "Create the database"
  task :create do
    config_file = "config/database.yml"
    if File.exists?(config_file)
      config = YAML.load(File.new(config_file))[:development]
      puts "Creating database '#{config[:database]}'"
      args = ["--user=#{config[:username]}"]
      args << "--password=#{config[:password]}" if config[:password]
      args << "-e create database #{config[:database]}"
      system('mysql', *args)
    else
      puts "Config file '#{config_file}' doesn't exist."
    end
  end
  
  desc "Drop database"
  task :drop do
    config_file = "config/database.yml"
    if File.exists?(config_file)
      config = YAML.load(File.new(config_file))[:development]
      puts "Dropping database '#{config[:database]}'"
      args = ["--user=#{config[:username]}"]
      args << "--password=#{config[:password]}" if config[:password]
      args << "-e drop database #{config[:database]}"
      system('mysql', *args)
    else
      puts "Config file '#{config_file}' doesn't exist."
    end
  end
  
  desc "Run database migrations"
  task :migrate do
    DataMapper.auto_migrate!
  end
  
  desc "Run database upgrade"
  task :upgrade do
    DataMapper.auto_upgrade!
  end
  
  desc "Setup database with default data for pre-populated tables"
  task :setup => [:migrate, :'wowbom:categories', :'wowbom:realms']  
end