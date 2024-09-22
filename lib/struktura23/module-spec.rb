module Struktura23
  class ModuleSpec
    def self.as_root
      raise "Root is already specified" if !!@root
      @root = Node::Base.new
    end
  end
end
