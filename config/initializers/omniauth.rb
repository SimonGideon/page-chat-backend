# OmniAuth is configured through Devise (config/initializers/devise.rb).
#
# For a React SPA (no Rails session/cookies), the frontend cannot supply a
# Rails CSRF token. We allow GET so a plain <a href="/api/v1/auth/google_oauth2">
# link works without CSRF token requirements.
OmniAuth.config.allowed_request_methods = %i[get post]
OmniAuth.config.silence_get_warning = true
