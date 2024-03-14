module Jobs
  class LearnedSkillService
    extend EventEmitter

    def self.create(job, master_skill_id)
      learned_skill = job.learned_skills.create!(id: SecureRandom.uuid, master_skill_id:)

      event_service.create!(
        event_schema: Events::LearnedSkillCreated::V1,
        job_id: job.id,
        data: Events::LearnedSkillCreated::Data::V1.new(
          id: learned_skill.id,
          job_id: job.id,
          master_skill_id:
        )
      )

      learned_skill
    end

    def self.destroy(learned_skill)
      learned_skill.destroy!

      event_service.create!(
        event_schema: Events::LearnedSkillDestroyed::V1,
        job_id: learned_skill.job_id,
        data: Events::LearnedSkillDestroyed::Data::V1.new(
          id: learned_skill.id
        )
      )
    end
  end
end
