# # Determine an item's value using wowecon, returning it as a currency value
# def item_value(item_id, options={:region => "EU", :realm => "Alonsus", :faction => "A"})
#   # TODO: implement caching
#   # TODO: bypass wowecon for items sold by vendors
#   # TODO: use vendor price for items not available on the market
# 
#   # example wowecon request:
#   # http://data.wowecon.com/?type=price&item_name=Inferno%20Ink&server_name=Alonsus&region=EU&faction=A
# 
#   item_name = URI.escape(item_name_from_id(item_id), Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
#   options.each do |k,v| 
#     options[k] = URI.escape(v, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
#   end
#   request_url = "http://data.wowecon.com/?type=price&item_name=#{item_name}&server_name=#{options[:realm]}&region=#{options[:region]}&faction=#{options[:faction]}"
#   wowecon_source = Nokogiri::HTML(open(request_url))
# 
#   # a typical returned value looks like this:
#   # <table class="wowecon_wowcurrency">
#   #   <tr>
#   #     <td class="wowcurrency_coin">183</td>
#   #     <td class="wowcurrency_coin"><img alt="g" src=""/></td>
#   #     <td class="wowcurrency_value">52</td>
#   #     <td class="wowcurrency_coin"><img alt="s" src=""/></td>
#   #     <td class="wowcurrency_value">63</td>
#   #     <td class="wowcurrency_coin"><img alt="c" src=""/></td>
#   #   </tr>
#   # </table>
# 
#   tds = wowecon_source.css('table.wowecon_wowcurrency tr td')
# 
#   currency_types = {:g => :gold, :s => :silver, :c => :copper}
#   currency_type = nil
#   currency = {:gold => 0, :silver => 0, :copper => 0}
# 
#   tds.reverse_each do |td|
#     if img = td.at_css('img')
#       coin = img.attribute('alt').content.match(/([gsc])/)
#       currency_type = currency_types[coin[0].to_sym]
#       next
#     end
# 
#     value = td.inner_text.strip.match(/([0-9]+)/)
#     if value
#       currency[currency_type] = value[0].to_i
#     end
#   end
# 
#   {:currency => currency, :precise => currency_to_float(currency)}
# end