class BulkRegister < ApplicationRecord
  belongs_to :user

  has_one_attached :user_uploaded_file
  has_one_attached :error_log

  enum :status, { pending: 0, processing: 5, finished: 10 }
end
