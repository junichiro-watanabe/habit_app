require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) do
    user = create(:user)
    user.groups.build(name: "valid_name",
                      habit: "valid_habit",
                      overview: "valid_overview")
  end

  describe "有効性のテスト" do
    it "有効な情報" do
      expect(group).to be_valid
    end

    it "nameが空白" do
      group.name = ""
      expect(group).not_to be_valid
    end

    it "nameが50文字超過" do
      group.name = "a" * 51
      expect(group).not_to be_valid
    end

    it "habitが空白" do
      group.habit = ""
      expect(group).not_to be_valid
    end

    it "habitが50文字超過" do
      group.habit = "a" * 51
      expect(group).not_to be_valid
    end

    it "overviewが255文字超過" do
      group.overview = "a" * 256
      expect(group).not_to be_valid
    end
  end
end
