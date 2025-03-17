require 'rails_helper'

describe 'Admin tries to access the page to upload a file for bulk registering', type: :system do
  it 'and succeeds', js: true do
    user = create(:user, role: :admin)
    login_as user

    visit bulk_registers_path

    expect(page).to have_content 'Você ainda não fez o upload de nenhum arquivo para registro em massa.'
    expect(page).to have_link 'Novo Upload'
  end
end
