module TestHelper
  def log_in_as(user, password: "password")
    post login_path, params: {session: {email: user.email,
                                        password: password}}
  end

  def log_in_as_system(user, password: "password")
    visit login_path
    fill_in email, with: user.email
    fill_in password, with: password
    click_button "ログイン"
  end
end
