require 'liquid'

namespace :qunit do
  namespace :check do
    
    desc "Identify all testable JS files and determine if test suites exist."
    task :coverage do
      js = QUnit::Generator.testable_js
      suites = QUnit::Generator.existing_test_suites
      js.each do |f|
        puts "Found JS file #{f.inspect}: #{suites.include?(f) ? "Tested (OK)" : "UNTESTED"}"
      end
    end
    
  end
  
  namespace :generate do
    desc "Forcefully generate test markup for all JS files in the top-level script directory, overwriting markup files that already exist."
    task :each do
      QUnit::Generator.testable_js.each do |testable_js|
        QUnit::Generator.generate_test_js(testable_js)
        QUnit::Generator.generate_test_markup(testable_js, :force)
      end
    end
    
    desc "Generate an 'all tests' HTML file"
    task :all do
      QUnit::Generator.testable_js.each do |testable_js|
          QUnit::Generator.generate_test_js(testable_js)
      end
      QUnit::Generator.generate_test_markup(:all, :force)
    end
    
    desc "Generate test markup for all JS files in the top-level script directory that do not already have test markup defined."
    task :missing do
      QUnit::Generator.testable_js.each do |testable_js|
        QUnit::Generator.generate_test_js(testable_js)
        QUnit::Generator.generate_test_markup(testable_js)
      end
    end
    
    desc "Generate test markup and js for a filename provided as an argument using '...:one[filename]' (don't forget the quotes)"
    task :one, :filename do |t, args|
      QUnit::Generator.generate_test_js(args.filename)
      QUnit::Generator.generate_test_markup(args.filename)
    end
    
  end
end

module QUnit  
  class Generator
    TESTABLE_JS_DIR = "public/javascripts"
    TEST_DIR        = "public/test"
    
    # Get an array of all testable file paths in the JS folder
    def self.testable_js
      Dir[File.join TESTABLE_JS_DIR, "*.js"].map {|f| File.basename(f.gsub(".js", "")) }
    end
    
    def self.missing_test_suites
      testable_js - existing_test_suites
    end
    
    def self.existing_test_suites
      Dir[File.join TEST_DIR, "*.html"].map {|f| File.basename(f.gsub(".test.html", "")) }
    end
    
    # Returns true if a suite was generated, false if already present (and not forced).
    # Raises an exception if the suite should have been generated but the generator encountered a problem.
    # Use name=:all to generate the all_tests file.
    def self.generate_test_markup(name, force=false)
      template_markup = File.open(File.join(TEST_DIR, "_template.test.html.liquid")).read
      template = Liquid::Template.parse(template_markup)
      
      dependency_script_tags = testable_js.collect do |n|
        "<script type\"text/javascript\" src=\"../javascripts/#{n}.js\"></script>"
      end.join("\n\t")
      
      if name == :all
        qunit_script_tags = testable_js.collect do |n| 
          "<script type\"text/javascript\" src=\"#{n}.test.js\"></script>"
        end.join("\n\t")
        markup_destination = File.join(TEST_DIR, "all_tests.test.html")
      else
        qunit_script_tags = "<script type\"text/javascript\" src=\"#{name}.test.js\"></script>"
        #dependency_script_tags = "<script type\"text/javascript\" src=\"../javascripts/#{name}.js\"></script>"
        markup_destination = File.join(TEST_DIR, "#{name}.test.html")
      end
      
      if File.exists?(markup_destination) and !force
        # Skip render and return false
        puts "--> Skipped writing markup to #{markup_destination} as file exists"
        return false
      else
        # Render and return true
        payload = {
          "qunit_script_tags" => qunit_script_tags, 
          "dependency_script_tags" => dependency_script_tags,
          "test_name" => ((name == :all)? "All Tests" : name)
        }
        rendered_markup = template.render(payload)              
        File.open(markup_destination, "w") {|f| f.write rendered_markup }
        puts "--> Wrote markup to #{markup_destination}"
        return true
      end
    end
    
    # Returns true if a suite was generated, false if already present (and not forced).
    # Raises an exception if the suite should have been generated but the generator encountered a problem.
    def self.generate_test_js(name, force=false)
      template_markup = File.open(File.join(TEST_DIR, "_template.test.js.liquid")).read
      template = Liquid::Template.parse(template_markup)
      
      js_destination = File.join(TEST_DIR, "#{name}.test.js")
      if File.exists?(js_destination) and !force
        # Skip render and return false
        puts "--> Skipped writing JS file to #{js_destination} as file exists"
        return false
      else
        # Render and return true
        payload = {"test_name" => name}
        rendered_js = template.render(payload)              
        File.open(js_destination, "w") {|f| f.write rendered_js }
        puts "--> Wrote test JS to #{js_destination}"
        return true
      end
    end
  end
end