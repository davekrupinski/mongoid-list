module Mongoid
  module List
    module Scoping
      extend ActiveSupport::Concern

      def list_scope_field
        fields["position"].options[:scope]
      end

      def list_scope_conditions
        list_scoped? ? { list_scope_field.to_sym => public_send(list_scope_field) } : {}
      end

    end
  end
end
