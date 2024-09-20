module Struktura23
  module Node
    class Base
      attr_reader :block_type, :block_label, :datasource

      def initialize(datasource, block_type, block_label=:this)
        @block_type = block_type
        @block_label = block_label
        @datasource = datasource
      end
    end

    class Singular < Base
      attr_reader :root

      def initialize(*args)
        @root = args.shift
        super(*args)
      end
    end

    class Optional < Base
    end

    class Plural < Base
    end
  end
end
