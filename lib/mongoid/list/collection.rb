require 'mongoid/list/abstract'

module Mongoid
  module List
    class Collection < Abstract

      class << self

        def update_positions!(klass, elements)
          load_list_elements(klass, elements).each_with_index do |element, idx|
            klass.collection.update({ _id: element.id }, { '$set' => { position: (idx + 1) } })
          end
          # return false if elements.size < klass.count
        end

      private

        def load_list_elements(klass, elements)
          elements.collect do |element|
            id = element.kind_of?(Hash) ? element['id'] : element
            klass.find(id)
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
