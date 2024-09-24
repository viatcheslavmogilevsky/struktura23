module Struktura23
  module Node
    class Base
      attr_reader :infra_block, :identifier, :query, :enforcers, :connected_nodes, :connection

      def initialize(infra_block, connection)
        @connected_nodes = []
        @enforcers = {}
        @query = {}
        @infra_block = infra_block
        @connection = connection
      end

      def has_one(block_type, block_label=:this)
        has(Connection::Singular, false, block_type, block_label)
      end

      def has_one_data(block_type, block_label=:this)
        has(Connection::Singular, true, block_type, block_label)
      end

      def has_optional(block_type, block_label=:this)
        has(Connection::Optional, false, block_type, block_label)
      end

      def has_optional_data(block_type, block_label=:this)
        has(Connection::Optional, true, block_type, block_label)
      end

      def has_many(block_type, block_label=:this)
        has(Connection::Plural, false, block_type, block_label)
      end

      def has_many_data(block_type, block_label=:this)
        has(Connection::Plural, true, block_type, block_label)
      end

      def belongs_to(block_type, block_label=:this)
        has(Connection::Reverse, false, block_type, block_label)
      end

      def enforce(enforce_hash)
        @enforcers.merge! enforce_hash
        self
      end

      # Stub
      def enforce_expression(enforce_hash, template_hash)
        @enforcers.merge! enforce_hash
        self
      end

      def identify_by(identifier_hash)
        @identifier = identifier_hash
        self
      end

      def where(query_hash)
        @query.merge! query_hash
        self
      end

      # Stub
      def enabled?
        StubTools::Chain.new(self)
      end

      # Stub
      def resolved
        StubTools::Chain.new(self)
      end

      # Stub
      def resolved_var
        StubTools::Chain.new(self)
      end

      private

      def has(connection_class, datasource, block_type, block_label)
        infra_block = InfraBlock.new(datasource, block_type, block_label)
        node = Base.new(infra_block, connection_class.new(self))
        @connected_nodes << node
        node
      end
    end
  end
end
