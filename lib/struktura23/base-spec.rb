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
    def has_many(*args)
    end

    def has_one(*args)
    end

    def has_optional_one(*args)
    end
  end

  class BaseSpec
    extend Providers
    extend Owner

    class << self
      def has_wrapper(wrapper_key, options={})
        named_wrappers[wrapper_key] = wrapper = Wrapper.new(options)
        wrapper_core = WrapperCore.new(wrapper.core_type)
        yield(wrapper, wrapper_core)
      end

      def named_wrappers
        @named_wrappers ||= {}
      end
    end
  end

  class Wrapper
    include Owner

    def initialize(options)
      @options = options
    end

    def core_type
      @options[:of]
    end

    def core
      WrapperCore.new
    end
  end


  class WrapperCore
    attr_reader :core_type

    def initialize(core_type)
      @core_type = core_type
    end

    def method_missing(name, *args, &block)
      puts "I don't care about #{name}"
    end
  end
end