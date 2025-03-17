class BulkRegister < ApplicationRecord
  belongs_to :user

  has_one_attached :user_uploaded_file
  has_one_attached :error_log
end
