class BulkRegistersFileReadingJob < ApplicationJob
  queue_as :default

  def perform(bulk_register)
    user_uploaded_file = bulk_register.user_uploaded_file
    bulk_register.status = :processing
    total_lines = 0

    user_uploaded_file.open do |f|
      file_content = f.read.force_encoding("UTF-8")

      file_content.each_line do |line|
        total_lines += 1
        AutomaticRecordCreationJob.perform_later(bulk_register, line)
      end

      bulk_register.total_lines = total_lines
      bulk_register.save!
    end
  end
end
