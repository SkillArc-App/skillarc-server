class DesiredCertification < ApplicationRecord
  belongs_to :master_certification
  belongs_to :job
end
