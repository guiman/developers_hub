require 'rails_helper'

describe RecruiterExtensions::SearchDevelopers do
  it "returns a list of developers with ruby and javascript" do
    ruby = Skill.create(name: "Ruby")
    js = Skill.create(name: "JavaScript")

    dev_1 = Developer.create(login: "test 1", hireable: true)
    dev_2 = Developer.create(login: "test 2", hireable: true)
    dev_3 = Developer.create(login: "test 3", hireable: true)

    dev_1.skills << ruby
    dev_2.skills << js
    dev_3.skills << ruby
    dev_3.skills << js

    search = RecruiterExtensions::SearchDevelopers.new(languages: ["  ruby  ", "javascript"]).search

    expect(search.count).to eq(1)
    expect(search.first).to eq(dev_3)
  end

  it "returns a list of developers in hampshire" do
    ruby = Skill.create(name: "Ruby")
    js = Skill.create(name: "JavaScript")

    Developer.create(login: "test 1", hireable: false, location: "Hampshire")
    dev_1 = Developer.create(login: "test 1", hireable: true, location: "Hampshire")
    dev_2 = Developer.create(login: "test 2", hireable: true, location: "London")
    dev_3 = Developer.create(login: "test 3", hireable: true, location: "Portsmouth")

    dev_1.skills << ruby
    dev_2.skills << js
    dev_3.skills << ruby

    search = RecruiterExtensions::SearchDevelopers.new(location: "hampshire").search

    expect(search.count).to eq(1)
    expect(search.first).to eq(dev_1)
  end

  it "returns a list of developers with ruby and javascript in hampshire" do
    ruby = Skill.create(name: "Ruby")
    js = Skill.create(name: "JavaScript")

    dev_1 = Developer.create(login: "test 1", hireable: true, location: "Hampshire")
    dev_2 = Developer.create(login: "test 2", hireable: true, location: "Portsmouth")
    dev_3 = Developer.create(login: "test 3", hireable: true, location: "Hampshire")
    dev_4 = Developer.create(login: "test 3", hireable: true, location: "Hampshire")

    dev_1.skills << ruby
    dev_2.skills << js
    dev_3.skills << ruby
    dev_3.skills << js
    dev_4.skills << ruby
    dev_4.skills << js

    search = RecruiterExtensions::SearchDevelopers.new(languages: ["ruby", "javascript"], location: "haMpsHire").search

    expect(search.count).to eq(2)
    expect(search.first).to eq(dev_3)
    expect(search.last).to eq(dev_4)
  end

end
