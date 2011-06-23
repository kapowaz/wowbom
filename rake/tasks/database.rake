require 'yaml'

namespace :db do
  desc "Create the database"
  task :create do
    config_file = "config/database.yml"
    if File.exists?(config_file)
      config = YAML.load(File.new(config_file))[:development]
      puts "Creating database '#{config[:database]}'"
      # puts "username: #{config[:username]}, password: #{config[:password]}, database: #{config[:database]}"
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
    # TODO
  end
end