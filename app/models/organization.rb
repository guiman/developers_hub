class Organization < ActiveRecord::Base
  serialize :languages
  serialize :activity, Array

  has_many :organization_skills
  has_many :skills, through: :developer_skills

  def activity_for_chart
    overall_activity = []
    activity_per_skill = {}

    activity_languages = activity.map { |act| act[:language] }.compact.uniq
    activity_languages.each { |skill| activity_per_skill[skill] = [] }

    from = (Date.today + 14.day) - 3.month
    to = Date.today
    period = (from..to).step(7)

    period.each do |week|
      current_range = ((week - 1.week)..week)

      # overall activity
      overall_activity << activity.select do |act|
        current_range.include?(act.fetch(:updated_at).to_date)
      end.count

      # per language activity
      activity_languages = activity.map { |act| act[:language] }.compact.uniq
      activity_languages.each do |skill|
        activity_per_skill[skill] << activity.select do |act|
          current_range.include?(act.fetch(:updated_at).to_date) && act.fetch(:language, nil).to_s == skill.to_s
        end.count
      end
    end

    # We need to group activity by date
    real_dates = period.to_a
    real_dates.map! { |d| "'#{d.strftime('%Y-%m-%d')}'".html_safe }
    real_dates.prepend('\'x\''.html_safe)

    activity_data = overall_activity
    activity_data.prepend('\'activity\''.html_safe)

    all_the_languages = activity_per_skill.keys.map do |lang|
      lang_activity = activity_per_skill[lang]
      lang_activity.prepend("'#{lang}'".html_safe)
      "[#{lang_activity.join(',')}]"
    end.join(',')


    "[#{real_dates.join(',')}], [#{activity_data.join(',')}], #{all_the_languages}"
  end

end
