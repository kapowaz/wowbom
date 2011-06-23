require 'rubygems'
require 'bundler'

Bundler.setup

Dir["#{File.dirname(__FILE__)}/rake/tasks/**/*.rake"].sort.each { |ext| load ext }

task :default do
  Dir["test/**/*.rb"].sort.each { |test| load test }
end