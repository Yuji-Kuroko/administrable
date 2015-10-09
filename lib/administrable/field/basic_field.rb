module Administrable
  module Field
    module BasicField
      def self.edit_fields(resource)
        resource.attributes.except('id', 'created_at', 'updated_at').keys
      end

      def self.show_fields(resource)
        fields = edit_fields(resource)
        fields << 'created_at' if resource.respond_to?('created_at')
        fields << 'updated_at' if resource.respond_to?('updated_at')
        fields
      end

      def self.field_type(klass, attr)
        # TODO:
        if klass.reflect_on_belongs_to_class(attr).present?
          :belongs_to
        elsif klass.defined_enums[attr].present?
          :enum
        elsif klass.columns_hash[attr].present?
          klass.columns_hash[attr].type
        else
          # Default type is string
          :string
        end
      end

      def self.field_type(klass, attr)
        # TODO:
        if klass.reflect_on_belongs_to_class(attr).present?
          :belongs_to
        elsif klass.defined_enums[attr].present?
          :enum
        elsif klass.columns_hash[attr].present?
          klass.columns_hash[attr].type
        else
          # Default type is string
          :string
        end
      end

      def self.data_for_select(klass, attr)
        # TODO:
        association = klass.reflect_on_belongs_to_class(attr)
        return [] if association.nil?
        if association.respond_to?(:list_for_select)
          association.list_for_select
        elsif association.new.attributes.include?('name')
          association.pluck(:name, :id)
        else
          raise Administrable::Field::MissingPrimaryNameException
        end
      end
    end
  end
end