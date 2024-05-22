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
      end

      def method_missing(name, *args, &block)
        puts "I'm #{node_type}.#{label} and I don't care about #{name}"
      end
    end

    class Collection < Base
    end

    class Singular < Base
    end

    class Optional < Base
    end
  end

  module Owner
    def has_many(*args)
      node = Node::Collection.new(*args)
      yield(node) if block_given?
      node
    end

    def has_one(*args)
      node = Node::Singular.new(*args)
      yield(node) if block_given?
      node
    end

    def has_optional_one(*args)
      node = Node::Optional.new(*args)
      yield(node) if block_given?
      node
    end

    # def has(node_klass, node_type, node_label=:main, &block)
    #   node = node_klass.new
    #   puts "I don't care about #{node_type}.#{node_label} (#{node})"
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