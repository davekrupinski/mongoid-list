require 'mongoid/list/abstract'

module Mongoid
  module List
    class Embedded < Abstract

      def update_positions!
        items.each do |item|
          next unless should_operate_on_item?(item)
          criteria  = { "#{relation_name}._id" => item.id }
          updates   = { '$inc' => { "#{relation_name}.$.position" => changes[:by] } }
          container.class.collection.update(criteria, updates)
        end
      end

      def count
        items.excludes(_id: obj.id).where(conditions).count
      end


    private


      def items
        container.send(relation_name)
      end

      def should_operate_on_item?(item)
        # TODO: This includes duplicate logic from :list_scope_conditions
        ![
          item == obj,
          changes[:min].present? && item.position < changes[:min],
          changes[:max].present? && item.position > changes[:max],
          obj.list_scoped? && item.list_scope_value != obj.list_scope_value
        ].any?
      end

      def container
        # TODO: MONGOID: Mongoid is not currently setting up the metadata properly so we have to do some extra
        # work with getting the values we need out of the partial information.
        obj.send(obj.metadata.inverse_setter.sub('=', '').to_sym)
      end

      def relation_name
        obj.metadata.name.to_sym
      end


    end
  end
end
