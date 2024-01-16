module AuthClient
  Error = Struct.new(:message, :status)
  Response = Struct.new(:decoded_token, :error)
end
