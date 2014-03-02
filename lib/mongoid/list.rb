require "mongoid/list"

module Mongoid

  # Fields.option :scope do |model, field, value|

  # end

  module List

    extend ActiveSupport::Concern

    autoload :Collection, 'mongoid/list/collection'
    autoload :Embedded,   'mongoid/list/embedded'

    included do
      attr_accessor   :_scope_list_update_to_previous
      class_attribute :mongoid_list_settings

      self.mongoid_list_settings = { scoped: false, scope: nil }

      before_create   :set_initial_position_in_list

      before_update   :reset_position_between_scopes, if: :list_scope_changing?

      before_update   :mark_for_update_processing_of_list, if: ->(d){ d.position_changed? && !d.list_scope_changing? }
      before_destroy  :mark_for_removal_processing_from_list

      after_update    :clear_list_scope_changing_state
      after_update    :update_positions_in_list!, if: :_process_list_change
      after_destroy   :update_positions_in_list!, if: :_process_list_change

      scope :ordered, -> { asc(:position) }
    end


    module ClassMethods

      def lists(opts={})

        field     :position, type: Integer

        if opts[:scope].present?
          self.mongoid_list_settings[:scoped] = true
          self.mongoid_list_settings[:scope]  = opts[:scope]
        end

        validates :position, numericality: true, on: :update
      end

      def update_positions_in_list!(elements, binding=nil)
        embedded? ? Embedded.update_positions!(binding, elements) : Collection.update_positions!(self, elements)
      end

    end


    attr_accessor :_process_list_change


    def list_scoped?
      self.class.mongoid_list_settings[:scoped]
    end

    def list_scope_field
      self.class.mongoid_list_settings[:scope]
    end

    def list_scope_value
      public_send(list_scope_field)
    end

    def list_scope_conditions
      list_scoped? ? { list_scope_field.to_sym => list_scope_value } : {}
    end

    # TODO: test
    def list_scope_changing_conditions
      { list_scope_field.to_sym => _scope_list_update_to_previous }
    end

    def list_scope_changing?
      @_list_scope_changing ||= (list_scoped? && changes.keys.include?(list_scope_field.to_s))
    end


  private


    def set_initial_position_in_list
      self.position = list_count + 1
    end

    def set_initial_scope_change_position_in_list
      self.position = list_count
    end

    def mark_for_update_processing_of_list
      self._process_list_change = if position_moving_up?
        { min: position_was, max: position, by: -1 }
      else
        { min: position, max: position_was, by: 1 }
      end
    end

    def clear_processing_of_list
      self._process_list_change = nil
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

    def reset_position_between_scopes
      set_list_scoping_to_previous_value
      move_list_to_new_scope!
      mark_for_removal_processing_from_list
      update_positions_in_list!
      clear_processing_of_list
      clear_list_scoping_from_previous_value
      set_initial_scope_change_position_in_list
      true
    end

    def move_list_to_new_scope!
      self.set({ list_scope_field => list_scope_value })
    end

    def set_list_scoping_to_previous_value
      self._scope_list_update_to_previous = changes[list_scope_field.to_s].first
    end

    def clear_list_scoping_from_previous_value
      self._scope_list_update_to_previous = nil
    end

    def clear_list_scope_changing_state
      remove_instance_variable(:@_list_scope_changing)
      true
    end

  end

end
