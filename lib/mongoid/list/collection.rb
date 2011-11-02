require 'mongoid/list/abstract'

module Mongoid
  module List
    class Collection < Abstract

      class << self

        def update_positions!(klass, elements)
          elements.each_with_index do |element, idx|
            id = element.kind_of?(Hash) ? element['id'] : element
            klass.collection.update({ _id: id }, { '$set' => { position: (idx + 1) } })
          end
        end

      end


      def update_positions!
        obj.class.collection.update(
          criteria,
          { '$inc' => { position: changes[:by] } },
          multi: true
        )
      end

      def count
        obj.class.where(conditions).count
      end

    private

      def criteria
        position = { '$lte' => changes[:max], '$gte' => changes[:min] }.delete_if { |k, v| v.nil? }
        conditions.merge({ _id:  { '$ne' => obj.id }, position: position })
      end

    end
  end
end
