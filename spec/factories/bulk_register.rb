FactoryBot.define do
  factory :bulk_register do
    user { association(:user, role: "admin") }
    user_uploaded_file { File.open(Rails.root.join('spec/support/files/text.txt'), filename: 'text.txt') }
    total_lines { 0 }
    success_count { 0 }
    lines_read { 0 }
  end
end
