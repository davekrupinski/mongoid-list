require 'mongoid/list/scoping'

module Mongoid


  module List
    extend ActiveSupport::Concern
    include Mongoid::List::Scoping

    autoload :Collection, 'mongoid/list/collection'
    autoload :Embedded,   'mongoid/list/embedded'

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
      self.position = list_count + 1
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
      embedded? ? Embedded.new(self).update_positions! : Collection.new(self).update_positions!
    end

    def list_count
      embedded? ? Embedded.new(self).count : Collection.new(self).count
    end


  end

end
