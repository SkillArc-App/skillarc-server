module TrainingProviders
  class TrainingProviderReactor < MessageReactor
    def can_replay?
      true
    end
  end
end
