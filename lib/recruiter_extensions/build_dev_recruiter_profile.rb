module RecruiterExtensions
  class BuildDevRecruiterProfile
    def initialize(auth_data)
      @auth_data = auth_data
    end

    def perform
      recruiter = DevRecruiter.find_by_uid(@auth_data.uid)

      unless recruiter
        recruiter = DevRecruiter.create(
          name: "#{@auth_data.info.first_name} #{@auth_data.info.last_name}",
          email: @auth_data.info.email,
          uid: @auth_data.uid,
          token: @auth_data.credentials.token,
          avatar_url: @auth_data.info.image,
          location: @auth_data.info.location)
      end

      recruiter
    end
  end
end
