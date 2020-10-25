module GroupsHelper
  def group_error_messages(errors)
    error_messages = []

    if errors.include?("Name can't be blank")
      error_messages << "コミュニティ名は空欄にできません"
    elsif errors.include?("Name is too long (maximum is 50 characters)")
      error_messages << "コミュニティ名は50文字以下にしてください"
    end

    if errors.include?("Habit can't be blank")
      error_messages << "習慣は空欄にできません"
    elsif errors.include?("Habit is too long (maximum is 50 characters)")
      error_messages << "習慣は50文字以下にしてください"
    end

    if errors.include?("Overview can't be blank")
      error_messages << "概要は空欄にできません"
    elsif errors.include?("Overview is too long (maximum is 255 characters)")
      error_messages << "概要は255文字以下にしてください"
    end

    error_messages
  end
end
