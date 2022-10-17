require "active_support/concern"

module ProtectRB
  module Model
    module DSL
      extend ActiveSupport::Concern
      class_methods do
        def secure_search(attribute, **options)
          @protect_rb_search_attrs ||= {}

          if duplicate_secure_search_attribute?(@protect_rb_search_attrs, attribute)
            raise ProtectRB::Error, "Attribute '#{attribute}' is already specified as a secure search attribute."
          end

          if !lockbox_encrypted?(self, attribute)
            raise ProtectRB::Error, "Attribute '#{attribute}' is not encrypted by Lockbox."
          end

          column_name =
            options.delete(:searchable_attribute) ||
              "#{attribute}_secure_search"

          if !ore_64_8_v1?(column_name)
            raise ProtectRB::Error, "Column name '#{column_name}' is not of type :ore_64_8_v1 (in `secure_search :#{attribute}`)"
          end

          @protect_rb_search_attrs[attribute] = {
            searchable_attribute: column_name.to_s,
            lockbox_attribute: lockbox_attributes[attribute]
          }
        end

        private

        def lockbox_encrypted?(model, attribute)
          return false if !model.respond_to?(:lockbox_attributes)
          return false if !model.lockbox_attributes.kind_of?(Hash)

          lockbox_attributes.has_key?(attribute)
        end

        def ore_64_8_v1?(column_name)
          columns_hash[column_name.to_s].sql_type_metadata.sql_type.to_sym == :ore_64_8_v1
        end

        def duplicate_secure_search_attribute?(attrs, attribute)
          attrs.has_key?(attribute)
        end
      end
    end
  end
end
