Trestle.resource(:reports) do
  menu do
    item :reports, icon: "fa fa-flag"
  end

  table do
    column :reporter, ->(report) { report.reporter&.email }
    column :reportable_type
    column :reason
    column :created_at, align: :center
    actions
  end

  form do |report|
    static_field :reporter, report.reporter&.email
    static_field :reportable_type
    static_field :reportable_id
    text_area :reason, readonly: true
    
    if report.reportable.present?
       static_field :content_preview, report.reportable.respond_to?(:body) ? report.reportable.body : "N/A"
    end
  end
end
