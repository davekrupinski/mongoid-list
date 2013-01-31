require 'mongoid/list/abstract'

module Mongoid
  module List
    class Embedded < Abstract

      class << self

        def update_positions!(binding, elements)
          load_list_elements(binding, elements).each_with_index do |element, idx|
            (binding.base._parent || binding.base).collection.update(
              element.atomic_selector,
              { "$set" => { "#{element.atomic_path}.$.position" => (idx+1) } }
            )
          end
        end

      private

        def load_list_elements(binding, elements)
          elements.collect do |element|
            id = element.kind_of?(Hash) ? element['id'] : element
            binding.base.send(binding.metadata.key).find(id)
          end
        end

      end


      def update_positions!
        items.each do |item|
          next unless should_operate_on_item?(item)
          criteria  = item.atomic_selector
          updates   = { '$inc' => { "#{item.atomic_path}.$.position" => changes[:by] } }
          item._root.class.collection.update(criteria, updates)
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
