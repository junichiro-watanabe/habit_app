module UsersHelper
  def user_error_messages(errors)
    error_messages = []

    if errors.include?("Name can't be blank")
      error_messages << "名前は空白にできません"
    elsif errors.include?("Name is too long (maximum is 50 characters)")
      error_messages << "名前は50文字以下にしてください"
    end

    if errors.include?("Email can't be blank")
      error_messages << "メールアドレスは空白にできません"
    elsif errors.include?("Email has already been taken")
      error_messages << "既にそのメールアドレスは使用されています"
    elsif errors.include?("Email is too long (maximum is 255 characters)")
      error_messages << "メールアドレスは255文字以下にしてください"
    elsif errors.include?("Email is invalid")
      error_messages << "メールアドレスが不正な値です"
    end

    if errors.include?("Password can't be blank")
      error_messages << "パスワードは空白にできません"
    elsif errors.include?("Password is too short (minimum is 8 characters)")
      error_messages << "パスワードは8文字以上に設定してください"
    elsif errors.include?("Password confirmation doesn't match Password")
      error_messages << "パスワード確認が一致しません"
    end

    error_messages
  end
end
