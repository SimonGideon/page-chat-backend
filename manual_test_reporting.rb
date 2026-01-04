# back-end/manual_test_reporting.rb
ENV['RAILS_ENV'] ||= 'development'
require_relative 'config/environment'

puts "Starting Reporting Test..."

# Clean up
User.where(email: ['test_author@example.com', 'r1@example.com', 'r2@example.com', 'r3@example.com']).destroy_all

# Setup
country = Country.first || Country.create!(code: 'US', name: 'United States')
city = City.where(name: 'Test City', country_code: 'US').first_or_create!

author = User.create!(
  email: 'test_author@example.com', 
  password: 'password', 
  first_name: 'Author', 
  last_name: 'Test', 
  country_code: country.code, 
  city_id: city.id, 
  date_of_birth: '1990-01-01', 
  gender: 'Male', 
  address: '123 St', 
  phone: '1234567890'
)

author.confirm # Auto-confirm to enable functionality

puts "Author created: #{author.id}"

book = Book.first || Book.create!(title: "Test Book", author_id: 1, category_id: 1, cover_image_url: "http://example.com/cover.jpg", published_date: Date.today)

discussion = Discussion.create!(
  title: "Test Discussion", 
  body: "This is a test discussion body.", 
  user: author, 
  book: book
)

puts "Discussion created: #{discussion.id} - Status: #{discussion.status}"

reporters = []
(1..3).each do |i|
  u = User.create!(
    email: "r#{i}@example.com", 
    password: 'password', 
    first_name: "Reporter", 
    last_name: "#{i}", 
    country_code: country.code, 
    city_id: city.id, 
    date_of_birth: '1990-01-01', 
    gender: 'Male', 
    address: '123 St', 
    phone: '1234567890'
  )
  u.confirm
  reporters << u
end

puts "Reporters created: #{reporters.map(&:id)}"

# Report 1
Report.create!(reporter: reporters[0], reportable: discussion, reason: "Spam")
puts "Report 1 created. Discussion Status: #{discussion.reload.status}. Count: #{discussion.reports.count}"

# Report 2
Report.create!(reporter: reporters[1], reportable: discussion, reason: "Spam")
puts "Report 2 created. Discussion Status: #{discussion.reload.status}. Count: #{discussion.reports.count}"

# Report 3
Report.create!(reporter: reporters[2], reportable: discussion, reason: "Spam")
puts "Report 3 created. Discussion Status: #{discussion.reload.status}. Count: #{discussion.reports.count}"

if discussion.flagged?
  puts "SUCCESS: Discussion is flagged."
else
  puts "FAILURE: Discussion is NOT flagged."
end
