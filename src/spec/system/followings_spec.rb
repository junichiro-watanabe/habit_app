require 'rails_helper'

RSpec.describe "Followings", type: :system do
  before do
    @user = create(:user)
    4.times do |n|
      eval("user_#{n + 1} = create(:users)")
    end

  end
end
