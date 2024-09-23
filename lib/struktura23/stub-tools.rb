module Struktura23
  module StubTools
    class Chain
      attr_reader :valid_methods_chain

      def initialize(owner)
        @valid_methods_chain = []
        @owner = owner
      end

      def method_missing(method_name, *args)
        # TODO: validate?
        new_method = [method_name] + args
        @valid_methods_chain << new_method
        self
      end
    end
  end
end