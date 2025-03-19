class BulkRegister < ApplicationRecord
  belongs_to :user

  has_one_attached :user_uploaded_file
  has_one_attached :error_log

  enum :status, { pending: 0, processing: 5, finished: 10, failed: 15 }, default: :pending

  validates :user_uploaded_file, presence: true
  validate :user_uploaded_file_type

  after_update_commit -> { broadcast_replace_to "bulk_register_#{id}", partial: "bulk_registers/show", target: "bulk_register_#{id}", locals: { bulk_register: self } }

  def error_count
    self.lines_read - self.success_count
  end

  def progress_percentage
    total_lines_to_divide = self.total_lines == 0 ? 1 : self.total_lines
    (self.lines_read.to_f / total_lines_to_divide.to_f) * 100
  end

  private
  def user_uploaded_file_type
    allowed_types = [ "text/plain", "text/csv" ]

    errors.add(:user_uploaded_file, I18n.t("errors.messages.invalid_file_format")) unless self.user_uploaded_file.content_type.in?(allowed_types)
  end
end
