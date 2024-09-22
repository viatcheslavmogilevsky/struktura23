module Struktura23
  module Node
    class Base
      def has_one
      end

      def has_one_data
      end

      def has_optional
      end

      def has_optional_data
      end

      def has_many
      end

      def has_many_data
      end

      def belongs_to
      end

      private

      def has
      end
    end

    class Block < Base
      attr_reader :block_type, :block_label, :datasource

      def initialize(datasource, block_type, block_label=:this)
        @block_type = block_type
        @block_label = block_label
        @datasource = datasource
      end
    end

    # class Singular < BaseBlock
    # end

    # class Optional < BaseBlock
    # end

    # class Plural < BaseBlock
    # end
  end
end
