module Mongoid

  Fields.option :scope do |model, field, value|

  end

  module List

    extend ActiveSupport::Concern

    autoload :Collection, 'mongoid/list/collection'
    autoload :Embedded,   'mongoid/list/embedded'

    included do
      field :position, type: Integer

      validates :position, numericality: true, on: :update

      before_create  :set_initial_position_in_list
      before_update  :mark_for_update_processing_of_list, if: :position_changed?
      after_update   :update_positions_in_list!, if: :_process_list_change
      before_destroy :mark_for_removal_processing_from_list
      after_destroy  :update_positions_in_list!, if: :_process_list_change

      scope :ordered, -> { asc(:position) }
    end


    module ClassMethods

      def update_positions_in_list!(elements, binding=nil)
        embedded? ? Embedded.update_positions!(binding, elements) : Collection.update_positions!(self, elements)
      end

    end


    attr_accessor :_process_list_change


    def list_scoped?
      fields["position"].options.has_key?(:scope)
    end

    def list_scope_field
      fields["position"].options[:scope]
    end

    def list_scope_value
      public_send(list_scope_field)
    end

    def list_scope_conditions
      list_scoped? ? { list_scope_field.to_sym => list_scope_value } : {}
    end


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
