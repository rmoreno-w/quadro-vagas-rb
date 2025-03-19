class BulkRegistersFileReadingJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 1.second, attempts: 3

  def perform(bulk_register)
    user_uploaded_file = bulk_register.user_uploaded_file
    bulk_register.status = :processing
    bulk_register.lines_read = 0
    bulk_register.success_count = 0
    total_lines = 0

    error_log = Tempfile.new([ "error_log", ".txt" ])

    user_uploaded_file.open do |f|
      file_content = f.read.force_encoding("UTF-8")

      file_content.each_line do |line|
        total_lines += 1
        AutomaticRecordCreationJob.perform_later(bulk_register, line, total_lines)
      end
    end

    bulk_register.total_lines = total_lines
    bulk_register.error_log.attach(io: error_log, filename: "error_log.txt")
    bulk_register.save!
    error_log.close
    error_log.unlink
  end
end
