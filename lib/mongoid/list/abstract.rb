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
        if obj._scope_list_update_to_previous
          obj.list_scope_changing_conditions
        else
          obj.list_scope_conditions
        end
      end

    end
  end
end
