module Cereal
  extend ActiveSupport::Concern

  def to_camel_case(str)
    str.split('_').each_with_index.map { |word, index| index.zero? ? word : word.capitalize }.join
  end

  def deep_transform_keys(object, &block)
    case object
    when Hash
      object.each_with_object({}) do |(key, value), result|
        result[yield(key)] = deep_transform_keys(value, &block)
      end
    when Array
      object.map { |e| deep_transform_keys(e, &block) }
    else
      object
    end
  end
end
