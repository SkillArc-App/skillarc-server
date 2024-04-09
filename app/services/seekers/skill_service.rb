module Seekers
  class SkillService
    include MessageEmitter

    def initialize(seeker)
      @seeker = seeker
    end

    def create(master_skill_id:, description:)
      master_skill = MasterSkill.find(master_skill_id)

      skill = ProfileSkill.create!(
        id: SecureRandom.uuid,
        description:,
        master_skill:,
        seeker:
      )

      message_service.create!(
        schema: Events::SeekerSkillCreated::V1,
        seeker_id: seeker.id,
        data: {
          description:,
          skill_id: master_skill.id,
          name: master_skill.skill,
          type: master_skill.type
        }
      )

      skill
    end

    def update(skill, description:)
      skill.update!(description:)

      message_service.create!(
        schema: Events::SeekerSkillUpdated::V1,
        seeker_id: seeker.id,
        data: {
          description:,
          skill_id: skill.master_skill_id,
          name: skill.master_skill.skill,
          type: skill.master_skill.type
        }
      )

      skill
    end

    def destroy(skill)
      skill.destroy!

      message_service.create!(
        schema: Events::SeekerSkillDestroyed::V1,
        seeker_id: seeker.id,
        data: {
          description: skill.description,
          skill_id: skill.master_skill_id,
          name: skill.master_skill.skill,
          type: skill.master_skill.type
        }
      )

      skill
    end

    private

    attr_reader :seeker
  end
end
