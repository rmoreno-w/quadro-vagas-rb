require 'rails_helper'

RSpec.describe BulkRegistersFileReadingJob, type: :job do
  it 'should read a file with success' do
    bulk_register = create(:bulk_register)
    record_creation_job_spy = spy('AutomaticRecordCreationJob')
    stub_const('AutomaticRecordCreationJob', record_creation_job_spy)

    BulkRegistersFileReadingJob.perform_now(bulk_register)

    expect(bulk_register.status).to eq "processing"
    expect(bulk_register.total_lines).to eq 5
    expect(record_creation_job_spy).to have_received(:perform_later).exactly(5).times
  end
end
