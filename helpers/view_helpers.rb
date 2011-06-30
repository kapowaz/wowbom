module Sinatra
  module ViewHelpers
    def erb_with_output_buffer(buf = '')
      @_out_buf, old_buffer = buf, @_out_buf
      yield
      @_out_buf
    ensure
      @_out_buf = old_buffer
    end

    def capture_erb(*args, &block)
      erb_with_output_buffer { block_given? && block.call(*args) }
    end

    def erb_concat(text)
      @_out_buf << text if !@_out_buf.nil?
    end

    def snake_case(string)
      return string.downcase if string =~ /^[A-Z]+$/
      string.gsub(/([A-Z]+)(?=[A-Z][a-z]?)|\B[A-Z]/, '_\&') =~ /_*(.*)/
        return $+.downcase
    end

    def attributes(hash)
      a = []
      hash.each_pair do |k,v|
        a.push "#{snake_case(k.to_s).sub(/^(.{1,1})/) { |m| m.downcase }}=\"#{v}\""
      end
      a.join(' ')
    end

    def tag(name, attrs = {}, &block)
      if block_given?
        erb_concat "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>#{capture_erb(&block)}</#{name}>"
      elsif !attrs[:content].nil?
        "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>#{attrs[:content]}</#{name}>"
      else
        "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>"
      end
    end
    
    def script_tag(attrs={})
      attrs.merge!({
        :type => "text/javascript",
        :charset => "utf-8"
      })
      attrs[:src] = "/js/#{attrs[:src]}.js" unless attrs[:src].nil?
      "#{tag :script, attrs}</script>"
    end
    
    def link_to(text, href, attrs={})
      attrs.merge!({
        :href => href
      })
      "#{tag :a, attrs}#{text}</a>"
    end

    def partial(template, options={})
      erb "_#{template}".to_sym, options.merge(:layout => false)
    end
    
    def navigation
      partial :navigation, :locals => {:items => @items, :page => @page}
    end
  end
   
  helpers ViewHelpers
end