module Core
  module RequestorMetadata
    class V1
      extend Core::Payload

      schema do
        requestor_type Either(*Requestor::Kinds::ALL)
        requestor_id Either(String, nil)
      end
    end
  end
end
