module Mongoid
  module List
    class Embedded

      attr_accessor :obj

      def initialize(obj)
        @obj = obj
      end

      def update_positions!
        items.each do |item|
          next unless should_operate_on_item?(item)
          criteria  = { "#{obj.metadata.name.to_sym}._id" => item.id }
          changes   = { '$inc' => { "#{obj.metadata.name.to_sym}.$.position" => obj._process_list_change[:by] } }
          _embedded_list_container.class.collection.update(criteria, changes)
        end
      end

      def count
        _embedded_list_container.send(obj.metadata.name.to_sym).excludes(_id: obj.id).where(obj.list_scope_conditions).count
      end


    private


      def items
        _embedded_list_container.send(obj.metadata.name.to_sym)
      end

      def should_operate_on_item?(item)
        # TODO: This includes duplicate logic from :list_scope_conditions
        ![
          item == obj,
          obj._process_list_change[:min].present? && item.position < obj._process_list_change[:min],
          obj._process_list_change[:max].present? && item.position > obj._process_list_change[:max],
          obj.list_scoped? && item.list_scope_value != obj.list_scope_value
        ].any?
      end

      def _embedded_list_container
        # TODO: MONGOID: Mongoid is not currently setting up the metadata properly so we have to do some extra
        # work with getting the values we need out of the partial information.
        obj.send(obj.metadata.inverse_setter.sub('=', '').to_sym)
      end


    end
  end
end
