Trestle.resource(:categories) do
  menu do
    item :categories, icon: "fa fa-tag", group: :library
  end

  table do
    column :name
    column :description
    column :created_at, align: :center
    actions
  end

  form do |_category|
    text_field :name
    text_area :description, rows: 4
  end

  params do |params|
    params.require(:category).permit(:name, :description)
  end
end

