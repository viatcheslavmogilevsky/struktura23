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
  end
end
