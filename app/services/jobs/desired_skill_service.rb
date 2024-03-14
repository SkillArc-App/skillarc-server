module Jobs
  class DesiredSkillService
    extend EventEmitter

    def self.create(job, master_skill_id)
      desired_skill = job.desired_skills.create!(id: SecureRandom.uuid, master_skill_id:)

      event_service.create!(
        event_schema: Events::DesiredSkillCreated::V1,
        job_id: job.id,
        data: Events::DesiredSkillCreated::Data::V1.new(
          id: desired_skill.id,
          job_id: job.id,
          master_skill_id:
        )
      )

      desired_skill
    end

    def self.destroy(desired_skill)
      desired_skill.destroy!

      event_service.create!(
        event_schema: Events::DesiredSkillDestroyed::V1,
        job_id: desired_skill.job_id,
        data: Events::DesiredSkillDestroyed::Data::V1.new(
          id: desired_skill.id
        )
      )
    end
  end
end
