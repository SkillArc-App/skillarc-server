module Core
  class UuidKeyValuePair
    extend Core::Payload

    schema do
      key Uuid
      value String
    end
  end
end
