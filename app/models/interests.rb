module Interests
  def self.table_name_prefix
    "interests_"
  end

  INTEREST_STREAM = Streams::Interest.new(interests_id: "fa16a321-f59a-454c-81c6-89d066364404")
end
