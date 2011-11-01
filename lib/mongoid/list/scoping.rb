module Mongoid
  module List
    module Scoping

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

    end
  end
end
