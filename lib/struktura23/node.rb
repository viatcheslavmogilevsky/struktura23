module Struktura23
  module Node
    class Base
      attr_reader :block_type, :block_label, :datasource, :root_claim

      def initialize(datasource, block_type, block_label=:this)
        @block_type = block_type
        @block_label = block_label
        @datasource = datasource

        @root_claim = false
      end

      def as_root
        @root_claim = true
        self
      end
    end

    class Singular < Base
    end

    class Optional < Base
    end

    class Plural < Base
    end
  end
end
