class BulkRegister < ApplicationRecord
  belongs_to :user

  has_one_attached :user_uploaded_file
  has_one_attached :error_log

  enum :status, { pending: 0, processing: 5, finished: 10 }, default: :pending

  validates :user_uploaded_file, presence: true
  validate :user_uploaded_file_type

  private
  def user_uploaded_file_type
    allowed_types = [ "text/plain", "text/csv" ]

    errors.add(:user_uploaded_file, I18n.t("errors.messages.invalid_file_format")) unless self.user_uploaded_file.content_type.in?(allowed_types)
  end
end
