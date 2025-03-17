require 'rails_helper'

describe 'User tries to create a bulk register', type: :request do
  context 'and fails to get the form ' do
    it 'for not being authenticated' do
      create(:user, role: :admin)

      get(new_bulk_register_path)

      expect(response).to redirect_to new_session_path
      expect(response.status).to eq 302
    end

    it 'for not being an admin' do
      user = create(:user)
      login_as user

      get(new_bulk_register_path)

      expect(response).to redirect_to root_path
      expect(response.status).to eq 302
    end
  end

  context 'and fails to create a bulk register through a post request' do
    it 'for being unauthenticated' do
      create(:user, role: :admin)
      file = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'text.txt'), 'text/plain')

      post(bulk_registers_path, params: { bulk_register: { user_uploaded_file: file } })

      expect(response).to redirect_to new_session_path
      expect(response.status).to eq 302
    end


    it 'for not being an admin' do
      user = create(:user)
      login_as user
      file = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'text.txt'), 'text/plain')

      post(bulk_registers_path, params: { bulk_register: { user_uploaded_file: file } })

      expect(response).to redirect_to root_path
      expect(response.status).to eq 302
    end
  end
end
