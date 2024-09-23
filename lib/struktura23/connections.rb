module Struktura23
  module Connection
    class Base
      attr_reader :owner

      def initialize(owner)
        @owner = owner
      end
    end

    class Singular < Base
    end

    class Optional < Base
    end

    class Plural < Base
    end

    class Reverse < Base
    end
  end
end