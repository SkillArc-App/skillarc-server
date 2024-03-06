module Seekers
  class SkillService
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

      EventService.create!(
        event_schema: Events::SeekerSkillCreated::V1,
        seeker_id: seeker.id,
        data: Events::SeekerSkillCreated::Data::V1.new(
          description:,
          skill_id: master_skill.id,
          name: master_skill.skill,
          type: master_skill.type
        )
      )

      skill
    end

    def update(skill, description:)
      skill.update!(description:)

      EventService.create!(
        event_schema: Events::SeekerSkillUpdated::V1,
        seeker_id: seeker.id,
        data: Events::SeekerSkillUpdated::Data::V1.new(
          description:,
          skill_id: skill.master_skill_id,
          name: skill.master_skill.skill,
          type: skill.master_skill.type
        )
      )

      skill
    end

    def destroy(skill)
      skill.destroy!

      EventService.create!(
        event_schema: Events::SeekerSkillDestroyed::V1,
        seeker_id: seeker.id,
        data: Events::SeekerSkillDestroyed::Data::V1.new(
          description: skill.description,
          skill_id: skill.master_skill_id,
          name: skill.master_skill.skill,
          type: skill.master_skill.type
        )
      )

      skill
    end

    private

    attr_reader :seeker
  end
end
