module Struktura23
  module Entrypoint
    def entrypoint
      @entrypoint ||= []
    end

    def is_repeatable?
      entrypoint.length == 1
    end

    def entrypoint?
      entrypoint.length > 0
    end

    def has_one resource
      entrypoint << resource
    end
  end


  class BaseSpec
    extend Entrypoint
  end
end