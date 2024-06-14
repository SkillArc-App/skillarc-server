module Qualifications
  class QualificationsAggregator < MessageConsumer
    def reset_for_replay
      MasterSkill.delete_all
      MasterCertification.delete_all
    end

    on_message Events::MasterSkillCreated::V1 do |message|
      MasterSkill.create!(
        id: message.aggregate.id,
        skill: message.data.skill,
        type: message.data.type
      )
    end

    on_message Events::MasterCertificationCreated::V1 do |message|
      MasterCertification.create!(
        id: message.aggregate.id,
        certification: message.data.certification
      )
    end
  end
end
