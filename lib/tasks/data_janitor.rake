namespace :data_janitor do
  desc "Unify developers"
  task unify_developers: :environment do
    duplicated_developers = Developer.select("login, count(id) as login_count").group("login").having("login_count > 1")
    duplicated_developers.each do |dev|
      developers = Developer.where(login: dev.login)
      real_developer = developers.first
      copied_developer = developers.last
      real_developer.email ||= copied_developer.email
      real_developer.location ||= copied_developer.location
      real_developer.geolocation ||= copied_developer
      real_developer.hireable ||= copied_developer.hireable
      real_developer.languages ||= copied_developer.languages
      real_developer.gravatar_url ||= copied_developer.gravatar_url
      real_developer.uid ||= copied_developer.uid
      real_developer.token ||= copied_developer.token

      real_developer.save
      copied_developer.delete
    end
  end
end
