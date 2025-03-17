FactoryBot.define do
  factory :bulk_register do
    user { association(:user, role: "admin") }
    user_uploaded_file { File.open(Rails.root.join('spec/support/files/text.txt'), filename: 'text.txt') }
  end
end
