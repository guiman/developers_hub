namespace :skills do
  desc "Gets skills from each developer and puts them into skills table and then associates with developers."
  task from_developers: :environment do
    devs = Developer.all.to_a

    devs.each do |dev|
      next if dev.languages.nil?
      dev.languages.each do |lang, count|
        skill = Skill.find_or_create_by(name: lang)
        dev_skill = DeveloperSkill.create(developer: dev, skill: skill, strength: count)
        raise "Could not create #{dev_skill}" unless dev_skill.errors.empty?
      end
    end
  end
end
