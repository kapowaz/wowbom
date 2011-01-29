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