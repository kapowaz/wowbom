module Sinatra
  module GenericHelpers

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

    # Get the realm list from the battle.net site
    def get_realms
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
            :status => realm.at_css("td.status").attribute("data-raw").to_s,
            :type => realm.at_css("td.type").attribute("data-raw").to_s,
            :population => realm.at_css("td.population").attribute("data-raw").to_s,
            :locale => realm.css("td.locale").inner_text.strip
          }) unless realm.css("td.name").empty?
        end
        realms[source_url[:label].to_sym] = realms[source_url[:label].to_sym].sort_by {|realm| realm[:name] }
      end

      realms
    end

    # display the realm list select
    def realmlist
      realms = {}
      partial :_realmlist, :locals => {:realms => realms}
    end

    # Find an item's recipe by ID on wowhead.com
    def recipe_by_id(item_id)
      # TODO: implement caching

      id_search = Nokogiri::XML(open("http://www.wowhead.com/item=#{item_id}&xml"))

      if id_search.css('wowhead error').length == 1
        {:error => "not found"}
      else
        if id_search.css('wowhead item createdBy').length == 1
          total_cost = 0
          reagents = []
          reagents_xml = id_search.css('wowhead item createdBy spell reagent')
          reagents_xml.each do |reagent|

            # determine if this reagent can be bought from a vendor (source: 5)
            # TODO: this needs to ignore items sold by vendors for something other than cash!
            # reagent_json["source"].include?(5) ? vendor_price(reagent.attribute('id')) : item_value(reagent.attribute('id'))[:precise]
            reagent_search = Nokogiri::XML(open("http://www.wowhead.com/item=#{reagent.attribute('id')}&xml"))
            reagent_json = JSON "{#{reagent_search.css('wowhead item json').inner_text.strip}}"
            item_cost = item_value(reagent.attribute('id'))[:precise]
            total_cost += item_cost * reagent.attribute('count').content.to_i

            reagents.push({
              :item_id => reagent.attribute('id').to_s,
              :name => reagent.attribute('name').to_s,
              :icon => reagent.attribute('icon').to_s,
              :quality => reagent.attribute('quality').content.to_i,
              :quantity => reagent.attribute('count').content.to_i,
              :price => item_cost
            })
          end
          recipe = {
            :item_id => item_id,
            :name => id_search.css('wowhead item name').inner_text.strip.to_s,
            :icon => id_search.css('wowhead item icon').inner_text.strip.to_s,
            :level => id_search.css('wowhead item level').inner_text.strip,
            :quality => id_search.css('wowhead item quality').attribute('id').content.to_i,
            :reagents => reagents,
            :price => total_cost
          }
          recipe
        else
          # this item can't be crafted
          recipe = {
            :item_id => item_id,
            :name => id_search.css('wowhead item name').inner_text.strip.to_s,
            :icon => id_search.css('wowhead item icon').inner_text.strip.to_s,
            :level => id_search.css('wowhead item level').inner_text.strip,
            :quality => id_search.css('wowhead item quality').attribute('id').content.to_i,
            :reagents => [],
            :price => 0,
            :notcrafted => true
          }
        end
      end
    end

    # Find an item's ID by name on wowhead.com
    def item_id_from_name(name)
      # TODO: implementation
      nil
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

    # Output an item's icon
    # TODO: needs to more absolutely determine the location of all these icons (and maybe just cache them all locally anyway?)
    def item_icon(item)
      open_tag :img, :src => "http://eu.battle.net/wow-assets/static/images/icons/56/#{item[:icon].downcase}.jpg", :class => "icon"
    end

    # Determine an item's value using wowecon, returning it as a currency value
    def item_value(item_id, options={:region => "EU", :realm => "Alonsus", :faction => "A"})
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

    # determine the vendor price of an item, or 0 if not sold by a vendor
    def vendor_price(item_id)
      # TODO: implementation!
      #
      # Checking the (non-XML) source for an item page should find the following JSON structure, indicating a vendor price
      # {
      #   template: 'npc', 
      #   id: 'sold-by', 
      #   name: LANG.tab_soldby, 
      #   tabs: tabsRelated, 
      #   parent: 'lkljbjkb574', 
      #   hiddenCols: ['level', 'type'], 
      #   extraCols: [Listview.extraCols.stock, Listview.funcBox.createSimpleCol('stack', 'stack', '10%', 'stack'), Listview.extraCols.cost], 
      #   data: [
      #     {
      #       "classification":0,
      #       "id":49703,
      #       "location":[4922],
      #       "maxlevel":84,
      #       "minlevel":84,
      #       "name":"Casandra Downs",
      #       "react":[1,undefined],
      #       "tag":"Alchemy & Inscription Supplies",
      #       "type":7,
      #       stock:3,
      #       stack:1,
      #       cost:[315804]
      #     },
      #     {
      #       "classification":0,
      #       "id":50248,
      #       "location":[4922],
      #       "maxlevel":84,
      #       "minlevel":84,
      #       "name":"Una Kobuna",
      #       "react":[undefined,1],
      #       "tag":"Alchemy and Inscription Supplies",
      #       "type":7,
      #       stock:3,
      #       stack:1,
      #       cost:[315804]
      #     }
      #   ]
      # }
      0
    end

    # translate a floating point number into a hash of gold, silver and copper currencies
    def currency(price)
      currency = {:gold => 0, :silver => 0, :copper => 0}
      formatted_price   = sprintf("%.4f", price).split(".")
      currency[:gold]   = formatted_price[0].to_i
      currency[:silver] = formatted_price[1][0,2].to_i
      currency[:copper] = formatted_price[1][2,2].to_i
      currency
    end

    # translate a currency into a floating point number
    def currency_to_float(currency)
      (currency[:gold] + (currency[:silver].to_f / 100) + (currency[:copper].to_f / 10000)).to_f
    end

    # Return the markup for a given amount of gold, silver and copper currency
    def currency_tags(currency)
      coins = [:gold, :silver, :copper]
      tag_output = ""
      coins.each do |coin|
        if currency[coin] > 0 || tag_output.length > 0
          tag_output += tag :var, currency[coin], :class => coin.to_s
        end
      end
      tag_output
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
  
  helpers GenericHelpers
end