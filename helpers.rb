module Helpers
  
  def filter_nil!(hash)
    hash.each_pair {|key, value| hash.delete key if value.nil?}
  end
  
  def partial(template, options={})
    erb template, options.merge(:layout => false)
  end
  
  def navigation_tab(text, path, options={}, link_options={})
    tag :li, link_to(text, path, link_options), filter_nil!({:class => request.path == path ? "selected" : nil})
  end

  # Display a list of all realms
  def realmlist
    realms = {}
    # TODO: implement caching here
    
    source_urls = [
      {:label => "us", :url => "http://us.battle.net/wow/en/status"}, 
      {:label => "eu", :url => "http://eu.battle.net/wow/en/status"}]

    source_urls.each do |source_url|
      realms[source_url[:label].to_sym] = []
      
      source = Nokogiri::HTML(open(source_url[:url]))
      realm_list = source.css("div#all-realms table tr")
      realm_list.each do |realm|
        realms[source_url[:label].to_sym].push({
          :name => realm.css("td.name").inner_text.strip,
          :status => realm.at_css("td.status").attribute("data-raw"),
          :type => realm.at_css("td.type").attribute("data-raw"),
          :population => realm.at_css("td.population").attribute("data-raw"),
          :locale => realm.css("td.locale").inner_text.strip
        }) unless realm.css("td.name").empty?
      end
      realms[source_url[:label].to_sym] = realms[source_url[:label].to_sym].sort_by {|realm| realm[:name] }
    end

    partial :_realmlist, :locals => {:realms => realms}
  end
  
  # Find an item's recipe by ID on wowhead.com
  def recipe_by_id(id)
    # TODO: implement caching
    
    id_search = Nokogiri::XML(open("http://www.wowhead.com/item=#{id}&xml"))
    if id_search.css('wowhead error').length == 1
      {:error => "not found"}
    else
      if id_search.css('wowhead item createdBy')
        reagents = []
        reagents_xml = id_search.css('wowhead item createdBy spell reagent')
        reagents_xml.each do |reagent|
          reagents.push ({
            :item_id => reagent.attribute('id'),
            :name => reagent.attribute('name'),
            :quality => reagent.attribute('quality').content.to_i,
            :quantity => reagent.attribute('count'),
            :price => 0
          })
        end
        recipe = {
          :item_id => id,
          :name => id_search.css('wowhead item name').inner_text.strip,
          :level => id_search.css('wowhead item level').inner_text.strip,
          :quality => id_search.css('wowhead item quality').attribute('id').content.to_i,
          :reagents => reagents,
          :price => 0
        }
        recipe
      else
        # this item can't be crafted
        {:error => "not crafted"}
      end
    end
  end
  
  # Find an item's recipe by name on wowhead.com
  def recipe_by_name(name)
    # to implement...
    
  end
  
  # Output an item's recipe markup
  def recipe(recipe)
    partial :_recipe, :locals => {:recipe => recipe}
  end
  
  # Return the markup for the value in gold, silver and copper for a given value
  def gold_value(price)
    currency = {:gold => 0, :silver => 0, :copper => 0}
    currency[:gold] = price.floor
    currency[:silver] = ((price - currency[:gold]) * 100).floor
    currency[:copper] = (((price - currency[:gold] * 100) - currency[:silver]) * 100).floor
    
    tags = {}
    currency.each do |type, value|
      tags[type] = tag :var, value, :class => type.to_s
    end
    
    if currency[:gold] == 0
      if currency[:silver] == 0
        tags[:copper]
      else
        currency[:copper] == 0 ? tags[:silver] : "#{tags[:silver]}#{tags[:copper]}"
      end
    else
      if currency[:silver] == 0
        currency[:copper] == 0 ? tags[:gold] : "#{tags[:gold]}#{tags[:silver]}#{tags[:copper]}"
      else
        currency[:copper] == 0 ? "#{tags[:gold]}#{tags[:silver]}" : "#{tags[:gold]}#{tags[:silver]}#{tags[:copper]}"
      end
    end
  end
  
  # Return a classname based on an integer-based item quality value
  def quality_class(quality)
    classname = case quality
      when 0 then "poor"
      when 1 then "common"
      when 2 then "uncommon"
      when 3 then "rare"
      when 4 then "epic"
      when 5 then "legendary"
      when 6 then "artifact"
      when 7 then "heirloom"
      else "poor"
    end
    classname
  end
  

  # a bunch of methods stolen from merb to help with general markup stuff
  def capture_erb(*args, &block)
    _old_buf, @_erb_buf = @_erb_buf, ""
    block.call(*args)
    ret = @_erb_buf
    @_erb_buf = _old_buf
    ret
  end
  
  def capture(*args, &block)
    ret = nil

    captured = capture_erb(*args) do |*args|
      ret = yield *args
    end

    # return captured value only if it is not empty
    captured.empty? ? ret.to_s : captured
  end
  
  def snake_case
    return self.downcase if self =~ /^[A-Z]+$/
    self.gsub(/([A-Z]+)(?=[A-Z][a-z]?)|\B[A-Z]/, '_\&') =~ /_*(.*)/
      return $+.downcase
  end
  
  def to_xml_attributes
    map do |k,v|
      %{#{k.to_s.snake_case.sub(/^(.{1,1})/) { |m| m.downcase }}="#{v}"}
    end.join(' ')
  end

  def tag(name, contents = nil, attrs = {}, &block)
    attrs, contents = contents, nil if contents.is_a?(Hash)
    # commented out until capture can be fixed...
    # contents = capture(&block) if block_given?
    open_tag(name, attrs) + contents.to_s + close_tag(name)
  end

  def open_tag(name, attrs = nil)
    "<#{name}#{' ' + attrs.to_xml_attributes unless attrs.nil?}>"
  end

  def close_tag(name)
    "</#{name}>"
  end
  
  def link_to(name, url='', opts={})
    opts[:href] ||= url
    %{<a #{ opts.to_xml_attributes }>#{name}</a>}
  end
  
  def extract_options_from_args!(args)
    args.pop if (args.last.instance_of?(Hash))
  end
  
  def cycle(*values)
    options = extract_options_from_args!(values) || {}
    key = (options[:name] || :default).to_sym
    (@cycle_positions ||= {})[key] ||= {:position => -1, :values => values}
    unless values == @cycle_positions[key][:values]
      @cycle_positions[key] = {:position => -1, :values => values}
    end
    current = @cycle_positions[key][:position]
    @cycle_positions[key][:position] = current + 1
    values.at( (current + 1) % values.length).to_s
  end
end