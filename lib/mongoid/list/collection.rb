module Mongoid
  module List
    class Collection

      attr_accessor :obj

      def initialize(obj)
        @obj = obj
      end

      def update_positions!
        obj.class.collection.update(
          criteria,
          { '$inc' => { position: obj._process_list_change[:by] } },
          multi: true
        )
      end

      def count
        obj.class.where(obj.list_scope_conditions).count
      end

    private

      def criteria
        position = { '$lte' => obj._process_list_change[:max], '$gte' => obj._process_list_change[:min] }.delete_if { |k, v| v.nil? }
        obj.list_scope_conditions.merge({ _id:  { '$ne' => obj.id }, position: position })
      end

    end
  end
end
