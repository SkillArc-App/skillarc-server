# frozen_string_literal: true

module Attributes
  module MessageTypes
    EVENTS = [
      ATTRIBUTE_CREATED = 'attribute_created',
      ATTRIBUTE_UPDATED = 'attribute_updated',
      ATTRIBUTE_DELETED = 'attribute_deleted'
    ].freeze

    COMMANDS = [
      CREATE_ATTRIBUTE = 'create_attribute',
      UPDATE_ATTRIBUTE = 'update_attribute',
      DELETE_ATTRIBUTE = 'delete_attribute'
    ].freeze
  end
end
