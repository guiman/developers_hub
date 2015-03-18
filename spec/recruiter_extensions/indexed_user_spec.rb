require "spec_helper"

describe RecruiterExtensions::IndexedUser do
  it "can be stored in a database" do
    indexed_user = described_class.new
    indexed_user.login = "test"
    expect(indexed_user.save).to eq(true)
    expect(RecruiterExtensions::IndexedUser.find_by_login(indexed_user.login)).to eq(indexed_user)
  end

  it "can handle languages structure" do
    indexed_user = described_class.new
    languages = { ruby: 1, javascript: 2 }
    indexed_user.languages = languages
    indexed_user.save

    expect(indexed_user.languages).to eq(languages)
  end

  it "can be compared to another object" do
    indexed_user_a = described_class.new
    indexed_user_b = described_class.new

    expect(indexed_user_a).to eq(indexed_user_b)
    indexed_user_a.login = "another_login"
    expect(indexed_user_a).not_to eq(indexed_user_b)
  end
end
