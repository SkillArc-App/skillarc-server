module Messages
  class QueryContainer
    extend Record

    schema do
      relation ActiveRecord::Relation
      messages ArrayOf(Message)
    end
  end
end
