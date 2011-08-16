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
      elsif attrs.key? :content
        content = attrs.delete :content
        "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>#{content}</#{name}>"
      else
        "<#{name}#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>"
      end
    end
  
    def script_tag(attrs={}, &block)
      attrs.merge!({
        :type => "text/javascript",
        :charset => "utf-8"
      })
      if block_given?
        erb_concat "<script#{' ' + attributes(attrs) unless attrs.nil? || attrs.empty?}>#{capture_erb(&block)}</script>"
      else
        attrs[:src] = attrs[:src].to_s.match(/^http:\/\//) ? attrs[:src] : "/javascripts/#{attrs[:src]}.js"
        "#{tag :script, attrs}</script>"
      end
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
    
    # generate breadcrumb trail links for item categories
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
  
  # generate a DL list of fields
  def fieldlist(name, submit_label, fields=[])
    partial :fieldlist, :locals => {:name => name, :fields => fields, :submit_label => submit_label}
  end
  
  # generate an input field according to type
  def field_tag(fieldset_name, field={})
    classnames = []
    classnames.push field[:class] if field.key? :class
    classnames.push 'error' if field.key? :error
    classnames.push 'valid' if field.key? :valid
    field[:class] = classnames.join ' '
    
    error = field.delete :error
    
    case field[:element]
      when :input
        tag :input, field.reject {|k| k == :element || k == :label}.merge(filter_nil! :id => "#{fieldset_name}_#{field[:name]}", :title => error)
      when :select
        tag :select, :name => field[:name], :id => "#{fieldset_name}_#{field[:name]}" do
          field[:options].each do |option|
            if option.key? :optgroup
              tag :optgroup, :label => option[:optgroup] do
                option[:options].each do |o|
                  tag :option, :value => o[:value], :content => o[:text]
                end
              end
            else
              tag :option, :value => option[:value], :content => option[:text]
            end
          end
        end
    end
  end
  
  helpers ViewHelpers
end