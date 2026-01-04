Rswag::Api.configure do |c|
  c.openapi_root = Rails.root.join("swagger").to_s

  # This allows you to dynamically filter the swagger docs per request if needed.
  c.swagger_filter = lambda do |swagger, env|
    swagger["host"] = env["HTTP_HOST"]
    swagger
  end
end

