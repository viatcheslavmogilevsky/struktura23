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
    # TODO: TestDriver and assign block somewhere
    def enforce(attribute, &block)
      puts "I don't care about #{attribute}"
    end
  end

  module Node
    class Base
      include Enforceable

      attr_reader :node_type, :label

      def initialize(node_type, label=:main)
        @node_type = node_type
        @label = label
        @data_source = false
      end

      # TODO: enforcement + query instructions
      def where(*args)
        puts "I'm not even reachable at the moment"
      end

      # TODO: move to the top (has_many ... data???)
      def data_source(flag)
        @data_source = flag
      end

      # TODO: continue defining methods
      def method_missing(name, *args, &block)
        puts "I'm #{node_type}.#{label} and I don't care about #{name}"
      end
    end

    class Collection < Base
      # TODO: TestDriver and assign block somewhere
      def identify(&block)
        puts "I'm #{node_type}.#{label} and I don't care about how to identify"
      end
    end

    class Singular < Base
    end

    class Optional < Base
    end
  end

  module Owner
    # TODO: these methods will be removed
    def has_many(*args, &block)
      node = Node::Collection.new(*args)
      has!(node, &block)
    end

    def has_one(*args, &block)
      node = Node::Singular.new(*args)
      has!(node, &block)
    end

    def has_optional(*args, &block)
      node = Node::Optional.new(*args)
      has!(node, &block)
    end

    def core
    end

    def nodes
      @nodes ||= {}
    end

    def has!(node, &block)
      if block.arity == 2 and core
        yield(node, core)
      else
        yield(node)
      end

      nodes.merge!({node.node_type => {node.label => node}}) do |_, val1, val2|
        val1.merge val2
      end
    end

    # WIP:
    # def method_missing(method_name, *args, &block)
    #   if method_name =~ /has_(many|one|optional)(_data)?/
    #   else
    #     super(method_name, *args, &block)
    #   end
    # end
  end


  class BaseSpec
    extend Providers
    extend Owner

    class << self
      def has_wrapper(wrapper_key, options={})
        named_wrappers[wrapper_key] = wrapper = Wrapper.new(options)
        yield(wrapper, wrapper.core)
      end

      def named_wrappers
        @named_wrappers ||= {}
      end
    end
  end

  class Wrapper
    include Owner

    attr_reader :core

    def initialize(options)
      @options = options
      @core = WrapperCore.new(@options[:of])
    end
  end


  class WrapperCore
    include Enforceable

    def initialize(core_type)
      @core_type = core_type
    end
  end
end