require 'rails_helper'

describe 'Admin tries to access the page to upload a file for bulk registering', type: :system do
  it 'and succeeds', js: true do
    user = create(:user, role: :admin)
    login_as user
    file_reading_spy = spy('BulkRegistersFileReadingJob')
    stub_const('BulkRegistersFileReadingJob', file_reading_spy)

    visit bulk_registers_path
    click_on 'Novo Upload de Arquivo'
    attach_file('Arquivo', Rails.root.join('spec/support/files/text.txt'))
    click_on 'Criar Registro em Massa'

    expect(page).to have_content 'Upload de Arquivo de Registros feito com sucesso!'
    expect(page).to have_content 'text.txt'
    expect(page).to have_content 'Status: Pendente'
    bulk_register = BulkRegister.last
    expect(file_reading_spy).to have_received(:perform_later).with(bulk_register)
  end
end
