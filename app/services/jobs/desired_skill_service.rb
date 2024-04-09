module Jobs
  class DesiredSkillService
    extend MessageEmitter

    def self.create(job, master_skill_id)
      desired_skill = job.desired_skills.create!(id: SecureRandom.uuid, master_skill_id:)

      message_service.create!(
        schema: Events::DesiredSkillCreated::V1,
        job_id: job.id,
        data: {
          id: desired_skill.id,
          job_id: job.id,
          master_skill_id:
        }
      )

      desired_skill
    end

    def self.destroy(desired_skill)
      desired_skill.destroy!

      message_service.create!(
        schema: Events::DesiredSkillDestroyed::V1,
        job_id: desired_skill.job_id,
        data: {
          id: desired_skill.id
        }
      )
    end
  end
end
