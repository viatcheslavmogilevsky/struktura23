module Struktura23
  class BaseSpec
    @entrypoint = {}
    class << self
      def has_one rsr
        @entrypoint[:root] = rsr
      end
    end

  end
end