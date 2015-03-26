require 'rails_helper'

describe DeveloperUser do
  describe ".from_session" do
    it "returns a null user when session in nil" do
      user = DeveloperUser.from_session(nil)
      expect(user.developer).to be_a(NullDeveloper)
    end

    it "returns a null user when session in nil" do
      developer = Developer.create
      user = DeveloperUser.from_session(developer.id)
      expect(user.developer).to be_a(Developer)
    end
  end
end
