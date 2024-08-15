module Attributes
  def self.table_name_prefix
    "attributes_"
  end

  INDUSTRIES_STREAM = Streams::Attribute.new(attribute_id: "0f6f1f2f-daf3-46a0-8614-95500974b063")
  TRAINING_PROVIDER_STREAM = Streams::Attribute.new(attribute_id: "bb7e6e91-654e-4295-9309-1711eeeb8e17")
end
