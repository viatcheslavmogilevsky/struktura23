module Struktura23
  module HclBlock
    class Base
      attr_reader :header_list, :body

      def initialize(header_list, body={})
        @header_list = header_list
        @body = body
      end
    end
  end
end
