module Struktura23
  module Node
    class Base
      attr_reader :block_info, :identifier, :query, :enforcers, :connected_nodes, :connection

      def initialize(block_info, connection)
        @connected_nodes = []
        @enforcers = {}
        @query = {}
        @block_info = block_info
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

      def identify_by(identifier_hash)
        @identifier = identifier_hash
        self
      end

      def where(query_hash)
        @query.merge! query_hash
        self
      end

      # Stub
      def resolved
        StubTools::Chain.new(self)
      end

      # Stub
      def resolved_var
        StubTools::Chain.new(self)
      end

      # Generation starts here
      def generate_blocks
      end

      def all_connected_nodes
        all_connected_nodes = [self]
        connected_nodes.each do |cn|
          all_connected_nodes += cn.all_connected_nodes
        end
        all_connected_nodes
      end

      def reversed_connections
        result = []
        current_connection = connection
        until current_connection.owner == nil
          result << current_connection
          current_connection = current_connection.owner.connection
        end
        result
      end

      private

      def has(connection_class, datasource, block_type, block_label)
        block_info = BlockInfo.new(datasource, block_type, block_label)
        node = Base.new(block_info, connection_class.new(self))
        @connected_nodes << node
        node
      end
    end
  end
end
