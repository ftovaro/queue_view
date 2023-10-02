Rails.application.config.after_initialize do
  if Rails.const_defined?('Server')
    TurnManagerJob.perform_async
  end
end

