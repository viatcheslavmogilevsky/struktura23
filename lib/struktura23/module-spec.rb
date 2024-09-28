module Struktura23
  class ModuleSpec
    def self.module_itself
      raise "Root node is already specified" if !!@root
      @root = Node::Base.new(nil, Connection::Plural.new(nil))
    end

    def self.nodes
      @root.all_connected_nodes
    end

    # Stub
    def self.hcl_blocks
      []
    end

    def self.reverse_connections(node)
      result = []
      current_connection = node.connection
      until current_connection.owner == nil
        result << current_connection
        current_connection = current_connection.owner.connection
      end
      result
    end
  end
end
