class Wowbom < Sinatra::Base
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
        content = attrs.delete :content
        "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>#{content}</#{name}>"
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
      erb "partials/_#{template}".to_sym, options.merge(:layout => false)
    end
  
    def navigation
      partial :navigation, :locals => {:items => @items, :page => @page}
    end
  
    def breadcrumbs(options={:item => nil, :category => nil, :inventory_slot => nil})
      divider = tag :span, :class => "divider", :content => "&rarr;"
      href    = "/"
      buf     = link_to "Home", href, :class => "home"
      buf     += divider

    
      unless options[:item].nil?
        # breadcrumb trail to an item
        href += "category/#{options[:item].category.slug}"
        buf  += link_to options[:item].category.name, href, :class => "category", :'data-category-id' => options[:item].category.id
        buf  += divider
      
        href += "/#{options[:item].category.subcategory_slug}"
        buf  += link_to options[:item].category.subcategory_name, href, :class => "subcategory", :'data-subcategory-id' => options[:item].category.subcategory_id
        buf  += divider
      
        unless options[:item].inventory_slot == 0
          href += "/#{options[:item].inventory_slot_slug}"
          buf  += link_to options[:item].inventory_slot_name, href, :class => "inventoryslot", :'data-inventoryslot-id' => options[:item].inventory_slot
          buf  += divider
        end
      else
        # breadcrumb trail to a category
        unless options[:category].nil?
          href += "category/#{options[:category].slug}"
          buf  += link_to options[:category].name, href, :class => "category", :'data-category-id' => options[:category].id
          buf  += divider

          unless @subcategory_id.nil?
            href += "/#{options[:category].subcategory_slug}"
            buf  += link_to options[:category].subcategory_name, href, :class => "subcategory", :'data-subcategory-id' => options[:category].subcategory_id
            buf  += divider

            unless options[:inventory_slot].nil?
              href += "/#{options[:inventory_slot][:slug]}"
              buf  += link_to options[:inventory_slot][:name], href, :class => "inventoryslot", :'data-inventoryslot-id' => options[:inventory_slot][:id]
              buf  += divider
            end
          end
        else
          href += "category/"
          buf  += link_to "All Items", href, :class => "category", :'data-category-id' => nil
          buf  += divider
        end
      end
    
      buf
    end
  end
  
  helpers ViewHelpers
end