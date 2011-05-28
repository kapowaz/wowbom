require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'

Dir["#{File.dirname(__FILE__)}/rake/tasks/**/*.rake"].sort.each { |ext| load ext }

task :default do
  Dir["test/**/*.rb"].sort.each { |test| load test }
end