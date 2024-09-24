module Struktura23
  class ModuleSpec
    def self.module_itself
      raise "Root node is already specified" if !!@root
      @root = Node::Base.new(nil, Connection::Plural.new(nil))
    end
  end
end
