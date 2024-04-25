module Struktura23
  module Basic
    def entrypoint
      @entrypoint ||= {}
    end

    def has_one rsr
      entrypoint[:root] = rsr
    end
  end


  class BaseSpec
    extend Basic
    # class_attribute :entrypoint

    # class << self
    #   def has_one rsr
    #   end
    # end

  end
end