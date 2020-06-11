module Enum
  extend ActiveSupport::Concern

  included do
    def self.human_attribute_enum_val(attr_name, val)
      human_attribute_name("#{attr_name}.#{val}")
    end

    def human_attribute_enum(attr_name)
      self.class.human_attribute_enum_val(attr_name, self[attr_name])
    end
  end
end
