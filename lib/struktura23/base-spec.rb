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

  module Core
    def has_many(*args)
    end

    def has_one(*args)
    end

    def has_optional_one(*args)
    end

    def has_wrapper(*args)
    end
  end

  class BaseSpec
    extend Providers
    extend Core
  end
end