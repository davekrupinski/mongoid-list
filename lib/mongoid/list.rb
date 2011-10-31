require 'mongoid/list/scoping'

module Mongoid


  module List
    extend ActiveSupport::Concern
    include Mongoid::List::Scoping

    included do
      field :position, type: Integer

      validates :position, numericality: true, on: :update

      index [ include?(Mongoid::Paranoia) ? [ :deleted_at, 1 ] : nil, [ :position, -1 ] ].compact # TODO: MONGOID: Apply a patch

      before_create  :set_initial_position_in_list
      before_update  :mark_for_update_processing_of_list, if: :position_changed?
      after_update   :update_positions_in_list!, if: :_process_list_change
      before_destroy :mark_for_removal_processing_from_list
      after_destroy  :update_positions_in_list!, if: :_process_list_change

      scope :ordered, order_by: :position.asc
    end


    module ClassMethods

      def update_positions_in_list!(elements)
        return false if elements.size < count
        elements.each_with_index do |element, idx|
          id = element.kind_of?(Hash) ? element['id'] : element
          self.collection.update({ id: id }, { '$set' => { position: (idx + 1) } })
        end
      end

    end


    attr_accessor :_process_list_change


  private


    def set_initial_position_in_list
      self.position = current_list_maximum_position + 1
    end

    def mark_for_update_processing_of_list
      self._process_list_change = if position_moving_up?
        { min: position_was, max: position, by: -1 }
      else
        { min: position, max: position_was, by: 1 }
      end
    end

    def position_moving_up?
      position > position_was
    end

    def mark_for_removal_processing_from_list
      self._process_list_change = { min: position, max: nil, by: -1 }
    end

    def update_positions_in_list!
      embedded? ? update_positions_in_embedded_list! : update_positions_in_collection_list!
    end

    def update_positions_in_collection_list!
      position = { '$lte' => _process_list_change[:max], '$gte' => _process_list_change[:min] }.delete_if { |k, v| v.nil? }
      criteria = list_scope_conditions.merge({ _id:  { '$ne' => id }, position: position })
      self.class.collection.update(
        criteria,
        { '$inc' => { position: _process_list_change[:by] } },
        multi: true
      )
    end

    def update_positions_in_embedded_list!
      _embedded_list_container.send(metadata.name.to_sym).each do |list_item|
        # TODO: This includes duplicate logic from :list_scope_conditions
        next if list_item == self ||
                (_process_list_change[:min].present? && list_item.position < _process_list_change[:min]) ||
                (_process_list_change[:max].present? && list_item.position > _process_list_change[:max]) ||
                (list_scoped? && list_item.list_scope_value != list_scope_value)

        criteria  = { "#{metadata.name.to_sym}._id" => list_item.id }
        changes   = { '$inc' => { "#{metadata.name.to_sym}.$.position" => _process_list_change[:by] } }
        _embedded_list_container.class.collection.update(criteria, changes)
      end
    end

    def current_list_maximum_position
      if embedded?
        _embedded_list_container.send(metadata.name.to_sym).excludes(_id: id)
      else
        self.class
      end.where(list_scope_conditions).count
    end

    def _embedded_list_container
      # TODO: MONGOID: Mongoid is not currently setting up the metadata properly so we have to do some extra
      # work with getting the values we need out of the partial information.
      self.send(metadata.inverse_setter.sub('=', '').to_sym)
    end

  end

end
