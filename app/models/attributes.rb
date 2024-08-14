module Attributes
  def self.table_name_prefix
    "attributes_"
  end

  INDUSTRIES_STREAM = Streams::Attribute.new(attribute_id: "db6b0fb3-f46b-4078-a056-dce88f4706f6")
end
