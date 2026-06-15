Trestle.configure do |config|
  # == Customization Options
  #
  # Set the page title shown in the main header within the admin.
  #
  config.site_title = "Page Chat"

  # Set the text shown in the page footer within the admin.
  config.footer = "Page Chat Admin &copy; #{Time.current.year}".html_safe

  # == Navigation
  config.menu do
    item :dashboard, icon: "fa fa-home", priority: :first

    group "Library", priority: 1 do
      item :books,      icon: "fa fa-book"
      item :authors,    icon: "fa fa-pen-nib"
      item :categories, icon: "fa fa-tags"
    end

    group "People", priority: 2 do
      item :users, icon: "fa fa-users"
    end

    group "Locations", priority: 3 do
      item :countries, icon: "fa fa-globe"
      item :cities,    icon: "fa fa-map-marker"
    end

    group "Reports", priority: 4 do
      item :reports, icon: "fa fa-chart-bar"
    end
  end

  # Sets the default precision for timestamps (either :minutes or :seconds).
  # Defaults to :minutes.
  #
  # config.timestamp_precision = :minutes

  # == Mounting Options
  #
  # Set the path at which to mount the Trestle admin. Defaults to /admin.
  #
  # config.path = "/admin"

  # Toggle whether Trestle should automatically mount the admin within your
  # Rails application's routes. Defaults to true.
  #
  # config.automount = false

  # == Navigation Options
  #
  # Set the path to consider the application root (for title links and breadcrumbs).
  # Defaults to the same value as `config.path`.
  #
  # config.root = "/"

  # Set the initial breadcrumbs to display in the breadcrumb trail.
  # Defaults to a breadcrumb labeled 'Home' linking to to the application root.
  #
  # config.root_breadcrumbs = -> { [Trestle::Breadcrumb.new("Home", Trestle.config.root)] }

  # Set the default icon class to use when it is not explicitly provided.
  # Defaults to "fa fa-arrow-circle-o-right".
  #
  # config.default_navigation_icon = "fa fa-arrow-circle-o-right"

  # Add an explicit menu block to be added to the admin navigation.
  #
  # config.menu do
  #   group "Custom Group" do
  #     item "Custom Link", "/admin/custom", icon: "fa fa-car", badge: { text: "NEW!", class: "label-success" }, priority: :first
  #   end
  # end

  # == Extension Options
  #
  # Specify helper modules to expose to the admin.
  #
  # config.helper :all
  # config.helper -> { CustomHelper }

  # Register callbacks to run before, after or around all Trestle actions.
  #
  # config.before_action do |controller|
  #   Rails.logger.debug("Before action")
  # end
  #
  # config.after_action do |controller|
  #   Rails.logger.debug("After action")
  # end
  #
  # config.around_action do |controller, block|
  #   Rails.logger.debug("Around action (before)")
  #   block.call
  #   Rails.logger.debug("Around action (after)")
  # end

  # Specify a custom hook to be injected into the admin.
  #
  # config.hook(:stylesheets) do
  #   stylesheet_link_tag "custom"
  # end

  # Toggle whether Turbolinks is enabled within the admin.
  # Defaults to true if Turbolinks is available.
  #
  # config.turbolinks = false

  # Specify the parameters that should persist across requests when
  # paginating or reordering. Defaults to [:sort, :order, :scope].
  #
  # config.persistent_params << :query

  # List of methods to try calling on an instance when displayed by the `display` helper.
  # Defaults to [:display_name, :full_name, :name, :title, :username, :login, :email].
  #
  # config.display_methods.unshift(:admin_label)

  # Customize the default adapter class used by all admin resources.
  # See the documentation on Trestle::Adapters::Adapter for details on
  # the adapter methods that can be customized.
  #
  # config.default_adapter = Trestle::Adapters.compose(Trestle::Adapters::SequelAdapter)
  # config.default_adapter.include MyAdapterExtensions

  # Register a form field type to be made available to the Trestle form builder.
  # Field types should conform to the following method definition:
  #
  # class CustomFormField
  #   def initialize(builder, template, name, options={}, &block); end
  #   def render; end
  # end
  #
  # config.form_field :custom, -> { CustomFormField }

  # == Debugging Options
  #
  # Enable debugging of form errors. Defaults to true in development mode.
  #
  # config.debug_form_errors = true

  # == Authentication (trestle-auth)
  # Use the basic backend with Devise password checks. The Devise+JWT API mapping
  # does not support cookie/session login via Warden for the admin form.
  config.auth.backend = :basic
  config.auth.user_class = -> { User }
  config.auth.authenticate_with = :email
  config.auth.authenticate = ->(params) {
    creds = params[:user] || params["user"] || params
    email = creds[:email] || creds["email"]
    password = creds[:password] || creds["password"]
    user = User.find_for_database_authentication(email: email)
    return unless user&.valid_password?(password)
    return unless user.confirmed? && user.active_for_authentication? && user.admin?

    user
  }
end
