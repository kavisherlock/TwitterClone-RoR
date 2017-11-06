require 'rails_helper'

SIGNUP_PAGE_TITLE = 'Sign up | NotTwitter'.freeze

feature 'Sign up page' do
  scenario 'Sign up form' do
    visit signup_path
    expect(page).to have_title SIGNUP_PAGE_TITLE
    expect(page).to have_css 'h1', text: 'Sign up'
    expect(page).to have_css 'form', class: 'new_user'
    expect(page).to have_css 'label', text: 'Name'
    expect(page).to have_css 'input', id: 'user_name'
    expect(page).to have_css 'label', text: 'Email'
    expect(page).to have_css 'input', id: 'user_email'
    expect(page).to have_css 'label', text: 'Handle'
    expect(page).to have_css 'input', id: 'user_handle'
    expect(page).to have_css 'label', text: 'Password'
    expect(page).to have_css 'input', id: 'user_password'
    expect(page).to have_css 'label', text: 'Password confirmation'
    expect(page).to have_css 'input', id: 'user_password_confirmation'
  end

  scenario 'Successful Sign Up' do
    sign_up_with('User', 'user@example.com', 'user', 'password', 'password')
    expect(current_path).to eql(user_path(1))
    expect(page).to have_content 'User successfully created'
  end

  scenario 'Empty input in Sign Up' do
    sign_up_with('', '', '', '', '')
    expect(page).to have_content 'Namecan\'t be blank'
    expect(page).to have_content 'Emailcan\'t be blank'
    expect(page).to have_content 'Handlecan\'t be blank'
    expect(page).to have_content 'Passwordcan\'t be blank'
  end

  scenario 'Bad input in Sign Up' do
    sign_up_with('a' * 128, 'a', 'a' * 16, 'pass', 'password')
    expect(page).to have_content 'Nameis too long (maximum is 127 characters)'
    expect(page).to have_content 'Emailis invalid'
    expect(page).to have_content 'Handleis too long (maximum is 15 characters)'
    expect(page).to have_content'Passwordis too short (minimum is 6 characters)'
    expect(page).to have_content 'Password confirmationdoesn\'t match Password'
  end

  scenario 'Dupilcate email and handle' do
    sign_up_with('User', 'user@example.com', 'user', 'password', 'password')
    expect(page).to have_content 'User successfully created'

    sign_up_with('User', 'user@example.com', 'user', 'password', 'password')
    expect(page).to have_content 'Emailduplicate email'
    expect(page).to have_content 'Handleduplicate handle'
  end

  def sign_up_with(name, email, handle, password, password_confirmation)
    visit signup_path
    fill_in 'Name', with: name
    fill_in 'Email', with: email
    fill_in 'Handle', with: handle
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
    click_button 'Sign Up'
  end
end
