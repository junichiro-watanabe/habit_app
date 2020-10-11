require 'rails_helper'

RSpec.describe "Followings", type: :system do
  before do
    @user = create(:user)
    1.upto 5 do |n|
      eval("user_#{n} = create(:users)")
    end

  end
end
