require 'rails_helper'

RSpec.describe BulkRegister, type: :model do
  describe '#valid' do
    context '#presence' do
      it { should have_one_attached(:user_uploaded_file)  }
    end

    context '#file_format' do
      it 'should accept txt files' do
        bulk_register = build(:bulk_register, user_uploaded_file: nil)
        bulk_register.user_uploaded_file.attach(io: File.open('spec/support/files/text.txt'), filename: 'text.txt', content_type: 'text/plain')

        expect(bulk_register).to be_valid
      end

      it 'should accept csv files' do
        bulk_register = build(:bulk_register, user_uploaded_file: nil)
        bulk_register.user_uploaded_file.attach(io: File.open('spec/support/files/text.csv'), filename: 'text.csv', content_type: 'text/csv')

        expect(bulk_register).to be_valid
      end

      it 'should not accept other file types' do
        bulk_register = build(:bulk_register, user_uploaded_file: nil)
        bulk_register.user_uploaded_file.attach(io: File.open('spec/support/files/logo.png'), filename: 'logo.png', content_type: 'image/png')

        expect(bulk_register).not_to be_valid
      end
    end

    context '#automatic_status_attribution' do
      it 'should have pending state after creation' do
        bulk_register = create(:bulk_register)

        expect(bulk_register.status).to eq "pending"
      end
    end
  end
end
