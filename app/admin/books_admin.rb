Trestle.resource(:books) do
  menu do
    item :books, icon: "fa fa-book"
  end

  scope :all, default: true
  scope :featured do |books|
    books.where(featured: true)
  end
  scope :recommended do |books|
    books.where(recommended: true)
  end

  collection do |params|
    Book.search_by_term(params[:q])
  end

  table do
    column :title
    column :author, -> (book) { book.author&.name }
    column :category, -> (book) { book.category&.name }
    column :language
    column :featured, align: :center do |book|
      status_tag(book.featured? ? "Yes" : "No", book.featured? ? :success : :default)
    end
    column :recommended, align: :center do |book|
      status_tag(book.recommended? ? "Yes" : "No", book.recommended? ? :success : :default)
    end
    column :published_at, align: :center
    column :updated_at, header: "Updated", align: :center
    actions
  end

  form do |book|
    row do
      col(sm: 8) do
        text_field :title
        text_area :description, rows: 4
        select :language, Language.order(:name).pluck(:name, :code), include_blank: "-- Select Language --"
        select :author_id, Author.order(:name).pluck(:name, :id), include_blank: "-- Select Author --"
        select :category_id, Category.order(:name).pluck(:name, :id), include_blank: "-- Select Category --"
        text_field :edition
        text_field :publisher
        text_field :isbn
        number_field :page_count
        date_field :published_at
      end

      col(sm: 4) do
        concat raw(<<~HTML)
          <div class="form-group">
            <label class="control-label">Featured</label>
            <div>
              <label style="margin-right:16px;font-weight:normal">
                <input type="radio" name="book[featured]" value="1" #{book.featured? ? 'checked' : ''}> Yes
              </label>
              <label style="font-weight:normal">
                <input type="radio" name="book[featured]" value="0" #{book.featured? ? '' : 'checked'}> No
              </label>
            </div>
          </div>
          <div class="form-group">
            <label class="control-label">Recommended</label>
            <div>
              <label style="margin-right:16px;font-weight:normal">
                <input type="radio" name="book[recommended]" value="1" #{book.recommended? ? 'checked' : ''}> Yes
              </label>
              <label style="font-weight:normal">
                <input type="radio" name="book[recommended]" value="0" #{book.recommended? ? '' : 'checked'}> No
              </label>
            </div>
          </div>
          <hr class="my-3">
        HTML

        file_field :cover_image, accept: "image/png,image/jpeg,image/jpg,image/webp,image/avif,image/svg+xml"
        if book.cover_image.attached?
          concat raw('<div class="mt-1 mb-3 text-muted"><small>Current: ' + book.cover_image.filename.to_s + '</small></div>')
        end

        file_field :pdf, accept: "application/pdf"
        if book.pdf.attached?
          concat raw('<div class="mt-1 text-muted"><small>Current: ' + book.pdf.filename.to_s + '</small></div>')
        end
      end
    end
  end

  params do |params|
    params.require(:book).permit(
      :title,
      :description,
      :language,
      :edition,
      :publisher,
      :page_count,
      :published_at,
      :isbn,
      :featured,
      :recommended,
      :author_id,
      :category_id,
      :cover_image,
      :pdf
    )
  end
end
