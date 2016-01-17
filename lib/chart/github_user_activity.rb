module Chart
  class GithubUserActivity
    MONTHS=(1..12).to_a

    attr_reader :year_to_display

    def initialize(github_login, year = Time.now.year)
      @github_login = github_login
      @year_to_display = year
      @data = ArchiveClient.dev_stats(github_handle: @github_login, year_to_display: @year_to_display)
    end

    def any_activity?
      !@data.empty?
    end

    def languages
      @data.fetch("languages")
    end

    # Row explanation:
    # [ "month_name", ruby_prs, js_prs, pythong_prs ]
    #
    # Output:
    # [
    #  [ "january", 1, 2, 3 ],
    #  ...
    #  [ "dicember", 6, 0, 2 ],
    # ]
    def monthly_language_activity
      @data.fetch("activity")
    end

    def chart
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', 'Month')
      languages.each do |lang|
        data_table.new_column("number", lang.fetch("name"))
      end
      data_table.add_rows(monthly_language_activity)
      option = { }
      GoogleVisualr::Interactive::LineChart.new(data_table, option)
    end
  end
end
