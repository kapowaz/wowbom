module Sinatra
  module CurrencyHelpers
    def currency_denoms(value)
      f       = sprintf("%.4f", value).split(".")
      gold   = f[0].to_i
      silver = f[1][0,2].to_i
      copper = f[1][2,2].to_i
      
      {:gold => gold, :silver => silver, :copper => copper}
    end
    
    def currency_from_denoms(denoms)
      (denoms[:gold] + (denoms[:silver].to_f / 100) + (denoms[:copper].to_f / 10000)).to_f
    end
    
    def currency_tags(value)
      f       = sprintf("%.4f", value).split(".")
      gold   = f[0].to_i
      silver = f[1][0,2].to_i
      copper = f[1][2,2].to_i
      coins = [{:gold => gold}, {:silver => silver}, {:copper => copper}]
      tags  = ""
      coins.each do |coin|
        coin.each do |denom, value|
          if value > 0 || tags.length > 0
            tags += "<var class=\"#{denom.to_s}\">#{value.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")}</var>"
          end
        end
      end
      tags
    end

    def currency_string(value)
      f       = sprintf("%.4f", value).split(".")
      gold   = f[0].to_i
      silver = f[1][0,2].to_i
      copper = f[1][2,2].to_i
      coins = [{:gold => gold}, {:silver => silver}, {:copper => copper}]
      output = ""
      coins.each do |coin|
        coin.each do |denom, value|
          if value > 0 || output.length > 0
            output += "#{value.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")}#{denom.to_s[0,1]} "
          end
        end
      end
      output.strip
    end
  end
  
  helpers CurrencyHelpers
end