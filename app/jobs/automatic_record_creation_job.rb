class AutomaticRecordCreationJob < ApplicationJob
  queue_as :bulk_register_queue

  def perform(bulk_register, line, line_index)
    parameters = line.split(",")
    register_type = parameters.first

    updated_error_log = Tempfile.new([ "error_log", ".txt" ])
    bulk_register.error_log.open do |file|
      content = IO.read(file)
      updated_error_log.write(content)
    end

    error_line = ""

    if register_type == "U" && parameters.length != 4
      error_line = "#{I18n.t("errors.messages.wrong_number_of_parameters", type: "U", parameters: 3, line: line_index)}\n"

    elsif register_type == "U" && parameters.length == 4
      password = SecureRandom.alphanumeric(6)
      user = User.new(
        name: parameters[2],
        last_name: parameters[3],
        email_address: parameters[1],
        password: password, password_confirmation: password
      )

      if user.save
        bulk_register.success_count += 1
      else
        error_line = "#{I18n.t("errors.messages.error_processing_line", line_number: line_index, error_message: user.errors.full_messages.join(", "))}\n"
      end

    elsif register_type == "E" && parameters.length != 5
      error_line = "#{I18n.t("errors.messages.wrong_number_of_parameters", type: "E", parameters: 4, line: line_index)}\n"

    elsif register_type == "E" && parameters.length == 5
      user = User.find_by(id: parameters[4])
      if user.nil?
        error_line = "#{I18n.t("errors.messages.error_processing_invalid_user", user_id: parameters[4], line_number: line_index)}"
      else
        company_profile = CompanyProfile.new(
          name: parameters[1],
          website_url: parameters[2],
          contact_email: parameters[3],
          user: user
        )
        company_profile.logo.attach(io: File.open("spec/support/files/logo.png"), filename: "logo.png", content_type: "image/png")

        if company_profile.save
          bulk_register.success_count += 1
        else
          error_line = "#{I18n.t("errors.messages.error_processing_line", line_number: line_index, error_message: company_profile.errors.full_messages.join(", "))}\n"
        end
      end

    elsif register_type == "V" && parameters.length != 11
      error_line = "#{I18n.t("errors.messages.wrong_number_of_parameters", type: "V", parameters: 10, line: line_index)}\n"

    elsif register_type == "V" && parameters.length == 11
      company_profile = CompanyProfile.find_by(id: parameters[10])

      if company_profile.nil?
        error_line = "#{I18n.t("errors.messages.error_processing_invalid_company_profile", company_profile_id: parameters[10], line_number: line_index)}"
      else
        job_location = parameters[6] == "remote" ? "remote" : parameters[8]

        job_posting = JobPosting.new(
          title: parameters[1],
          description: parameters[2],
          salary: parameters[3],
          salary_currency: parameters[4],
          salary_period: parameters[5],
          work_arrangement: parameters[6],
          job_type_id: parameters[7],
          job_location: job_location,
          experience_level_id: parameters[9],
          company_profile: company_profile
        )

        if job_posting.save
          bulk_register.success_count += 1
        else
          error_line = "#{I18n.t("errors.messages.error_processing_line", line_number: line_index, error_message: job_posting.errors.full_messages.join(", "))}\n"
        end
      end

    elsif ([ "V", "E", "U" ].exclude? register_type) && register_type.length == 1
      error_line = "#{I18n.t("errors.messages.error_processing_line", line_number: line_index, error_message: I18n.t("errors.messages.wrong_operation"))}\n"

    else
      error_line = "#{I18n.t("errors.messages.error_processing_line", line_number: line_index, error_message: I18n.t("errors.messages.unprocessable_line"))}\n"
    end

    unless error_line.blank?
      error_line.encode("UTF-8")
      updated_error_log.puts(error_line)
      updated_error_log.rewind
      bulk_register.error_log.attach(io: updated_error_log, filename: "error_log.txt", content_type: "text/plain")
    end

    bulk_register.lines_read += 1
    bulk_register.status = :finished if bulk_register.lines_read == bulk_register.total_lines
    bulk_register.save!
  end
end
