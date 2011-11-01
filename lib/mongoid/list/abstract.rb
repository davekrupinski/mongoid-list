module Mongoid
  module List
    class Abstract

      attr_accessor :obj

      def initialize(obj)
        @obj = obj
      end

      def changes
        obj._process_list_change
      end


      def conditions
        obj.list_scope_conditions
      end

    end
  end
end
