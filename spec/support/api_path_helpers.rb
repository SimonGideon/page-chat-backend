module ApiPathHelpers
  def api_v1_path(path = "")
    raise ArgumentError, "path must start with '/'" unless path.start_with?("/")

    "/api/v1#{path}"
  end
end

