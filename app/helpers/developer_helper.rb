module DeveloperHelper
  def candidate_top_skills(candidate:, top:)
    candidate.developer_skills.where(origin: 'github').order(strength: :desc).limit(top).map do |dev_skill|
      "#{dev_skill.skill.name}: #{dev_skill.strength}"
    end.join(', ')
  end
end
