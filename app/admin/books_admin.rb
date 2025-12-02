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

  table do
    column :title
    column :author, -> (book) { book.author&.name }
    column :category, -> (book) { book.category&.name }
    column :language
    column :featured, align: :center
    column :recommended, align: :center
    column :published_at, align: :center
    column :updated_at, header: "Updated", align: :center
    actions
  end

  form do |book|
    tab :details do
      text_field :title
      text_area :description, rows: 4
      text_field :language
      select :author_id, Author.order(:name).pluck(:name, :id), include_blank: "-- Select Author --"
      select :category_id, Category.order(:name).pluck(:name, :id), include_blank: "-- Select Category --"
      text_field :edition
      text_field :publisher
      text_field :isbn
      number_field :page_count
      date_field :published_at
      check_box :featured
      check_box :recommended
    end

    tab :media do
      file_field :cover_image
      if book.cover_image.attached?
        concat raw('<div class="mt-2"><span>Current cover: ' + book.cover_image.filename.to_s + '</span></div>')
      end

      file_field :pdf
      if book.pdf.attached?
        concat raw('<div class="mt-2"><span>Current PDF: ' + book.pdf.filename.to_s + '</span></div>')
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

