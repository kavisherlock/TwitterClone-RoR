require 'rails_helper'

PAGE_TITLE = 'Sign up | NotTwitter'.freeze

feature 'SignUp page' do
  scenario 'Successful Sign Up' do
    visit '/signup'
    expect(page).to have_title PAGE_TITLE
    expect(page).to have_css 'h1', text: 'Sign up'
    sign_up_with('User', 'user@example.com', 'user', 'password', 'password')
    expect(current_path).to eql(user_path(1))
    expect(page).to have_content 'Not Twitter User successfully created User'
    expect(page).to have_css 'h1', text: 'User'
    expect(page).to have_css 'strong', text: 'Email:'
    expect(page).to have_css 'p', text: 'user@example.com'
    expect(page).to have_css 'strong', text: 'Handle:'
    expect(page).to have_css 'p', text: 'user'
  end

  scenario 'Empty input in Sign Up' do
    visit '/signup'
    expect(page).to have_title PAGE_TITLE
    expect(page).to have_css 'h1', text: 'Sign up'
    sign_up_with('', '', '', '', '')
    expect(page).to have_content 'Namecan\'t be blank'
    expect(page).to have_content 'Emailcan\'t be blank'
    expect(page).to have_content 'Handlecan\'t be blank'
    expect(page).to have_content 'Passwordcan\'t be blank'
  end

  scenario 'Bad input in Sign Up' do
    visit '/signup'
    expect(page).to have_title PAGE_TITLE
    expect(page).to have_css 'h1', text: 'Sign up'
    sign_up_with('a' * 128, 'a', 'a' * 16, 'pass', 'password')
    expect(page).to have_content 'Nameis too long (maximum is 127 characters)'
    expect(page).to have_content 'Emailis invalid'
    expect(page).to have_content 'Handleis too long (maximum is 15 characters)'
    expect(page).to have_content'Passwordis too short (minimum is 6 characters)'
    expect(page).to have_content 'Password confirmationdoesn\'t match Password'
  end

  scenario 'Dupilcate email and handle' do
    visit '/signup'
    expect(page).to have_title PAGE_TITLE
    expect(page).to have_css 'h1', text: 'Sign up'
    sign_up_with('User', 'user@example.com', 'user', 'password', 'password')
    expect(page).to have_content 'Not Twitter User successfully created User'

    visit '/signup'
    expect(page).to have_title PAGE_TITLE
    expect(page).to have_css 'h1', text: 'Sign up'
    sign_up_with('User', 'user@example.com', 'user', 'password', 'password')
    expect(page).to have_content 'Emailduplicate email'
    expect(page).to have_content 'Handleduplicate handle'
  end

  def sign_up_with(name, email, handle, password, password_confirmation)
    visit '/signup' # sign_up_path
    fill_in 'Name', with: name
    fill_in 'Email', with: email
    fill_in 'Handle', with: handle
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
    click_button 'Sign Up'
  end
end