module Employers
  class EmployerBlueprint < Blueprinter::Base
    identifier :id

    field :name
    field :logo_url
  end
end
