module Markaby
  # Class used by Markaby::Builder to store element options.  Methods called
  # against the CssProxy object are added as element classes or IDs.
  #
  # See the README for examples.
  class CssProxy
    def initialize(builder, stream, sym)
      @builder = builder
      @stream  = stream
      @sym     = sym
      @attrs   = {}
      
      @original_stream_length = @stream.length
      
      @builder.tag! sym
    end
    
    def respond_to?(sym, include_private = false)
      include_private || !private_methods.include?(sym.to_s) ? true : false
    end

  private

    # Adds attributes to an element.  Bang methods set the :id attribute.
    # Other methods add to the :class attribute.
    def method_missing(id_or_class, *args, &block)
      if id_or_class.to_s =~ /(.*)!$/
        @attrs[:id] = $1
      else
        id = id_or_class
        @attrs[:class] = @attrs[:class] ? "#{@attrs[:class]} #{id}".strip : id
      end

      unless args.empty?
        if args.last.respond_to? :to_hash
          @attrs.merge! args.pop.to_hash
        end
      end
      
      args.push(@attrs)
      
      while @stream.length > @original_stream_length
        @stream.pop
      end
      
      if block
        @builder.tag! @sym, *args, &block
      else
        @builder.tag! @sym, *args
      end
      
      self
    end
  end
end
