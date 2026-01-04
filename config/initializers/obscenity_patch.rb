# Fix for Obscenity gem using deprecated File.exists? in Ruby 3.2+
unless File.respond_to?(:exists?)
  class File
    def self.exists?(path)
      exist?(path)
    end
  end
end
