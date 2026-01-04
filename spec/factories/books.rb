FactoryBot.define do
  factory :book do
    title { "MyString" }
    author { "MyString" }
    description { "MyString" }
    publication_year { 1 }
    cover_image { "MyString" }
    language { "MyString" }
    publisher { "MyString" }
    page_count { 1 }
    isbn { "MyString" }
    featured { false }
  end
end
