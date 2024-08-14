module Industries
  def self.table_name_prefix
    "industries_"
  end

  INDUSTRIES_NAME = "Industries".freeze
  INDUSTRIES_STREAM = Streams::Industries.new(industries_id: "dccd3175-cd98-4bd4-a16d-c3453ada505b")
end
