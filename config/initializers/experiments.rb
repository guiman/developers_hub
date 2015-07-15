recruiter_client = Recruiter::API.build_client(configuration: {
      access_token: ENV.fetch('GITHUB_ACCESS_TOKEN') })
redis_client = Redis.new

ExperimentConfiguration = OpenStruct.new(redis_client: redis_client,
  recruiter_client: recruiter_client)
