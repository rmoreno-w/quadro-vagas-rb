require 'rails_helper'

RSpec.describe JobPosting, type: :model do
  context "#Valid?" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:salary) }
    it { should validate_numericality_of(:salary) }
    it { should validate_presence_of(:salary_currency) }
    it { should validate_presence_of(:salary_period) }
    it { should validate_presence_of(:work_arrangement) }
    it { should validate_presence_of(:description) }
    it { should belong_to :company_profile }
    it { should belong_to :job_type }
    it { should belong_to :experience_level }
  end
end
