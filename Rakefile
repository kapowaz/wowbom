require 'rubygems'
require 'bundler'
require 'rspec/core/rake_task'

Bundler.setup

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color', '-f d', '-r ./spec/spec_helper.rb']
  t.pattern = 'spec/**/*_spec.rb'
  t.fail_on_error = false
end

Dir["#{File.dirname(__FILE__)}/rake/tasks/**/*.rake"].sort.each { |ext| load ext }

task :default => :spec