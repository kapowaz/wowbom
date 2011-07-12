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

    # display the realm list select
    def realmlist(region)
      realms = Realm.all(:region => region)
      partial :realmlist, :locals => {:realms => realms, :region => region}
    end
    
    def uri_escape(string)
      URI.escape(string, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
    
    def uri_unescape(string)
      URI.unescape(string)
    end
  end
  
  helpers GenericHelpers
end