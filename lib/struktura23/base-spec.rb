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

  module Owner
    def has_many(*args, &block)
      has(*args, &block)
    end

    def has_one(*args, &block)
      has(*args, &block)
    end

    def has_optional_one(*args, &block)
      has(*args, &block)
    end


    def has(node_type, node_label=:main, &block)
      puts "I don't care about #{node_type}.#{node_label}"
    end
  end

  module Enforceable
    def enforce(attribute, &block)
      puts "I don't care about #{attribute}"
    end
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