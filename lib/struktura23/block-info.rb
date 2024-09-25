module Struktura23
  class BlockInfo
    attr_reader :block_type, :block_label, :datasource

    def initialize(datasource, block_type, block_label)
      @block_type = block_type
      @block_label = block_label
      @datasource = datasource
    end
  end
end
