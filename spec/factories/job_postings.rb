FactoryBot.define do
  factory :job_posting do
    sequence(:title) { |n| "Job Title #{n}" }
    company_profile { create(:company_profile) }
    sequence(:salary) { |n| n + 1 }
    salary_currency { :usd }
    salary_period { :monthly }
    work_arrangement { :remote }
    job_type { create(:job_type) }
    experience_level { create(:experience_level) }
    job_location { "City, Country" }
    description { "Something" }
  end
end
