module Struktura23
  module Providers
    def provider(*args)
      providers << args
    end

    def query_provider(*args)
      query_providers << args
    end

    def providers
      @providers ||= []
    end

    def query_providers
      @query_providers ||= []
    end
  end

  module Enforceable
    # TODO: TestDriver [1]
    def enforce(attribute, &block)
      enforcers[attribute] = block
    end

    def enforcers
      @enforcers ||= {}
    end
  end

  module Node
    class Base
      include Enforceable

      attr_reader :node_type, :label, :data_source, :wrapped_by, :input_enabled, :output_enabled

      def initialize(data_source, node_type, label=:main)
        @node_type = node_type
        @label = label
        @data_source = data_source
        @search_enabled = true
        @search_query = {}
        @input_enabled = true
        @output_enabled = true
      end


      def disable_input
        @input_enabled = false
      end

      def disable_output
        @output_enabled = false
      end

      def wrap_by(wrapper)
        if wrapper.core.core_type != @node_type
          raise "Wrapper of a #{wrapper.core.core_type} cannot be used to wrap a #{@node_type}"
        end
        @wrapped_by = wrapper
      end

      def wrap
        @wrapped_by = Wrapper.new(of: @node_type, id: nil)
        yield(@wrapped_by)
      end

      def where(predicate)
        if predicate == false
          @search_enabled = false
        else
          @search_query = predicate.transform_values do |v|
            v.is_a?(PromiseElement) ? v.resolve : v
          end
          # TODO: enforcement
        end
      end

      # TODO: continue defining methods
      def method_missing(name, *args, &block)
        puts "I'm #{node_type}.#{label} and I don't care about #{name}"
      end
    end

    class Collection < Base
      def initialize(*args)
        super(*args)
        @identificator = nil
      end

      # TODO: TestDrive [2]
      def identify(&block)
        @identificator = block
      end
    end

    class Singular < Base
    end

    class Optional < Base
    end
  end

  module Owner
    def core
    end

    def nodes
      @nodes ||= {}
    end

    def has!(node, &block)
      if block_given?
        if block.arity == 2 and core
          yield(node, core)
        else
          yield(node)
        end
      end

      nodes.merge!({node.node_type => {node.label => node}}) do |_, val1, val2|
        val1.merge val2
      end
    end

    def method_missing(method_name, *args, &block)
      if method_name =~ /^has_(many|one|optional)(_data)?$/
        node = case $1
        when "many"
          Node::Collection.new(!!$2, *args)
        when "one"
          Node::Singular.new(!!$2, *args)
        when "optional"
          Node::Optional.new(!!$2, *args)
        end
        has!(node, &block)
      else
        super(method_name, *args, &block)
      end
    end
  end


  class BaseSpec
    extend Providers
    extend Owner

    class << self
      def has_wrapper(wrapper_key, options={})
        named_wrappers[wrapper_key] = wrapper = Wrapper.new(options.merge({:id => wrapper_key}))
        yield(wrapper, wrapper.core)
        wrapper
      end

      def named_wrappers
        @named_wrappers ||= {}
      end
    end
  end

  class Wrapper
    include Owner

    attr_reader :core, :id

    def initialize(options)
      @core = WrapperCore.new(options[:of])
      @id = options[:id]
    end
  end


  class WrapperCore
    include Enforceable

    attr_reader :core_type

    def initialize(core_type)
      @core_type = core_type
    end

    def found
      PromiseElement.new(self)
    end
  end

  class PromiseElement
    attr_reader :referenced_to, :method_name, :method_args

    def initialize(referenced_to, method_name=nil, method_args=[])
      @referenced_to = referenced_to
      @method_name = method_name
      @method_args = method_args
    end

    def resolve
      klass = self.class
      stack = [self]
      current = self
      while current.referenced_to.is_a?(klass)
        stack << current.referenced_to
        current = current.referenced_to
      end
      stack.reverse
    end

    def method_missing(method_name, *args)
      self.class.new(self, method_name, args)
    end

    def inspect
      "#<#{self.class}:#{object_id} "\
        "@method_name=#{@method_name} "\
        "@method_args=#{@method_args} "\
        "@referenced_to=#<#{@referenced_to.class}:#{@referenced_to.object_id}>>"
    end
  end

end