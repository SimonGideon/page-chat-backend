Trestle.admin(:dashboard, priority: :first) do
  menu do
    item :dashboard, icon: "fa fa-home", priority: :first
  end

  controller do
    def index
      @book_count       = Book.count
      @author_count     = Author.count
      @category_count   = Category.count
      @user_count       = User.count
      @featured_count   = Book.where(featured: true).count
      @recommended_count = Book.where(recommended: true).count

      @recent_books   = Book.includes(:author, :category, cover_image_attachment: :blob)
                            .order(created_at: :desc).limit(8)
      @recent_users   = User.order(created_at: :desc).limit(6)

      @new_users_week  = User.where("created_at >= ?", 7.days.ago).count
      @new_books_month = Book.where("created_at >= ?", 30.days.ago).count
    end
  end
end

