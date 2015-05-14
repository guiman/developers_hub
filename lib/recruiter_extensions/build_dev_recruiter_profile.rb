module RecruiterExtensions
  class BuildDevRecruiterProfile
    def initialize(auth_data)
      @auth_data = auth_data
    end

    def perform
      recruiter = DevRecruiter.find_by_uid(@auth_data.uid)

      unless recruiter
        avatar = @auth_data.extra.raw_info.pictureUrls.values.last
        avatar = avatar.respond_to?(:first) ? avatar.first : @auth_data.extra.raw_info.pictureUrl
        recruiter = DevRecruiter.create(
          name: "#{@auth_data.info.first_name} #{@auth_data.info.last_name}".encode("UTF-8"),
          email: @auth_data.info.email,
          uid: @auth_data.uid,
          token: @auth_data.credentials.token,
          avatar_url: avatar,
          location: @auth_data.info.location)
      end

      recruiter
    end
  end
end
