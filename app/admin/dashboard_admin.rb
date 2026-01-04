Trestle.admin(:dashboard, priority: :first) do
  menu do
    item :dashboard, icon: "fa fa-home", priority: :first
  end

  controller do
    def index
      @book_count = Book.count
      @author_count = Author.count
      @category_count = Category.count
      @user_count = User.count
      @recent_books = Book.order(created_at: :desc).limit(5)
    end
  end
end

