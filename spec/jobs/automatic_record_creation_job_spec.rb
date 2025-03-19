require 'rails_helper'

RSpec.configure do |config|
  # Reset sequences on table IDS to avoid wrong ids in postgres
  config.before(:each) do
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end
end

RSpec.describe AutomaticRecordCreationJob, type: :job do
  it 'should proccess lines with success' do
    bulk_register = create(:bulk_register)
    JobType.create!(name: 'Full Time')
    ExperienceLevel.create!(name: 'Junior')

    BulkRegistersFileReadingJob.perform_now(bulk_register)

    expect {
      perform_enqueued_jobs
    }.to have_performed_job(AutomaticRecordCreationJob).exactly(5).times

    bulk_register.reload
    error_log_line_count = bulk_register.error_log.download.each_line.count

    expect(bulk_register.status).to eq "finished"
    expect(bulk_register.lines_read).to eq 5
    expect(bulk_register.success_count).to eq 5
    expect(bulk_register.error_count).to eq error_log_line_count
  end

  it 'should proccess lines with errors and log errors to the file' do
    bulk_register = create(:bulk_register)
    create(:user, name: 'Erika', last_name: 'Campus', email_address: 'erika@campus.com')
    bulk_register.user_uploaded_file.attach(io: File.open("spec/support/files/text_with_wrong_params.txt"), filename: "text_with_wrong_params.txt", content_type: "text/plain")
    JobType.create!(name: 'Full Time')
    ExperienceLevel.create!(name: 'Junior')

    BulkRegistersFileReadingJob.perform_now(bulk_register)

    expect {
      perform_enqueued_jobs
    }.to have_performed_job(AutomaticRecordCreationJob).exactly(11).times

    bulk_register.reload
    error_log_line_count = bulk_register.error_log.download.each_line.count

    expect(bulk_register.status).to eq "finished"
    expect(bulk_register.lines_read).to eq 11
    expect(bulk_register.success_count).to eq 1
    expect(bulk_register.error_count).to eq error_log_line_count
  end
end
