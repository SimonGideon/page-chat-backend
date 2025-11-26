Trestle.resource(:authors) do
  menu do
    item :authors, icon: "fa fa-pen-nib", group: :library
  end

  table do
    column :name
    column :email
    column :website
    column :social_handle
    column :created_at, align: :center
    actions
  end

  form do |author|
    text_field :name
    text_field :email
    text_area :biography, rows: 4
    text_field :website
    text_field :social_handle

    file_field :avatar
    if author.avatar.attached?
      div class: "mt-2" do
        span "Current avatar: #{author.avatar.filename}"
      end
    end
  end

  params do |params|
    params.require(:author).permit(:name, :email, :biography, :website, :social_handle, :avatar)
  end
end

