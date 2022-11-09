module Protect
  module ActiveRecordExtensions
    module UniquenessValidator
      def validate_each(record, attribute, value)
        protect_attr = record.class.protect_search_attrs[attribute.to_sym]
        if protect_attr
          value = record.read_attribute_for_validation(protect_attr[:searchable_attribute])
        end
        super(record, attribute, value)
      end

      # Change the attribute name here instead of in validate_each above for a
      # better error message
      def build_relation(klass, attribute, value)
        protect_attr = klass.protect_search_attrs[attribute.to_sym]
        if protect_attr
          attribute = protect_attr[:searchable_attribute]
        end
        super(klass, attribute, value)
      end
    end
  end
end
