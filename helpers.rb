module Helpers
  
  # generic stuff
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
  def recipe_by_id(item_id)
    # TODO: implement caching
    
    id_search = Nokogiri::XML(open("http://www.wowhead.com/item=#{item_id}&xml"))
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
            :price => item_value(reagent.attribute('id'))[:precise]
          })
        end
        recipe = {
          :item_id => item_id,
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
  
  # Determine an item's name from its ID on wowhead.com
  def item_name_from_id(item_id)
    # TODO: implement caching
    id_search = Nokogiri::XML(open("http://www.wowhead.com/item=#{item_id}&xml"))
    if id_search.css('wowhead error').length == 1
      nil
    else
      id_search.css('wowhead item name').inner_text.strip
    end
  end
  
  # Output an item's recipe markup
  def recipe(recipe)
    partial :_recipe, :locals => {:recipe => recipe}
  end
  
  # Determine an item's value using wowecon, returning it as a currency value
  def item_value(item_id, options={:region => "", :realm => "", :faction => ""})
    # TODO: implement caching
    # TODO: bypass wowecon for items sold by vendors
    # TODO: use vendor price for items not available on the market
    
    # example wowecon request:
    # http://data.wowecon.com/?type=price&item_name=Inferno%20Ink&server_name=Alonsus&region=EU&faction=A

    item_name = URI.escape(item_name_from_id(item_id), Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    options.each do |k,v| 
      options[k] = URI.escape(v, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
    request_url = "http://data.wowecon.com/?type=price&item_name=#{item_name}&server_name=#{options[:realm]}&region=#{options[:region]}&faction=#{options[:faction]}"
    wowecon_source = Nokogiri::HTML(open(request_url))
    
    # a typical returned value looks like this:
    # <table class="wowecon_wowcurrency">
    #   <tr>
    #     <td class="wowcurrency_coin">183</td>
    #     <td class="wowcurrency_coin"><img alt="g" src=""/></td>
    #     <td class="wowcurrency_value">52</td>
    #     <td class="wowcurrency_coin"><img alt="s" src=""/></td>
    #     <td class="wowcurrency_value">63</td>
    #     <td class="wowcurrency_coin"><img alt="c" src=""/></td>
    #   </tr>
    # </table>
    
    tds = wowecon_source.css('table.wowecon_wowcurrency tr td')
    
    currency_types = {:g => :gold, :s => :silver, :c => :copper}
    currency_type = nil
    currency = {:gold => 0, :silver => 0, :copper => 0}
    
    tds.reverse_each do |td|
      if img = td.at_css('img')
        coin = img.attribute('alt').content.match(/([gsc])/)
        currency_type = currency_types[coin[0].to_sym]
        next
      end
      
      value = td.inner_text.strip.match(/([0-9]+)/)
      if value
        currency[currency_type] = value[0].to_i
      end
    end
    
    {:currency => currency, :precise => currency_to_float(currency)}
  end
  
  # translate a floating point number into a hash of gold, silver and copper currencies
  def currency(price)
    currency = {:gold => 0, :silver => 0, :copper => 0}
    currency[:gold] = price.floor
    currency[:silver] = ((price - currency[:gold]) * 100).floor
    currency[:copper] = (((price - currency[:gold] * 100) - currency[:silver]) * 100).floor
    currency
  end
  
  # translate a currency into a floating point number
  def currency_to_float(currency)
    (currency[:gold] + (currency[:silver].to_f / 100) + (currency[:copper].to_f / 10000)).to_f
  end
  
  # Return the markup for a given amount of gold, silver and copper currency
  def currency_tags(currency)
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
end