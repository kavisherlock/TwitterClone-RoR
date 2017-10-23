require 'rails_helper'

PARTIAL_PAGE_TITLE = ' | NotTwitter'.freeze

feature 'User Profile page' do
  scenario 'User info' do
    user = FactoryGirl.create(:user)
    visit "/users/#{user.id}"
    expect(page).to have_title "#{user.name}#{PARTIAL_PAGE_TITLE}"
    expect(page).to have_css 'h1', text: user.name
    expect(page).to have_css 'p', text: "@#{user.handle}"
    expect(page).to_not have_css 'a', text: 'Delete'
  end
end

feature 'User Edit Profile page' do
  before do
    user = FactoryGirl.create(:user)
    visit login_path
    login_with(user.email, user.password, false)
    visit "/users/#{user.id}/edit"
  end

  scenario 'User profile form' do
    expect(page).to have_title "Edit Profile#{PARTIAL_PAGE_TITLE}"
    expect(page).to have_css 'h1', text: 'Edit Profile'
    expect(page).to have_css 'form', class: 'edit_user'
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

  scenario 'Successful Update' do
    update_to('User', 'user@example.com', 'user', 'password', 'password')
    expect(page).to have_content 'Profile updated.'
  end

  scenario 'Empty input in Sign Up' do
    update_to('', '', '', '', '')
    expect(page).to have_content 'Namecan\'t be blank'
    expect(page).to have_content 'Emailcan\'t be blank'
    expect(page).to have_content 'Handlecan\'t be blank'
  end

  scenario 'Bad input in Sign Up' do
    update_to('a' * 128, 'a', 'a' * 16, 'pass', 'password')
    expect(page).to have_content 'Nameis too long (maximum is 127 characters)'
    expect(page).to have_content 'Emailis invalid'
    expect(page).to have_content 'Handleis too long (maximum is 15 characters)'
    expect(page).to have_content'Passwordis too short (minimum is 6 characters)'
    expect(page).to have_content 'Password confirmationdoesn\'t match Password'
  end

  scenario 'Dupilcate email and handle' do
    user2 = FactoryGirl.create(:user2)
    update_to('User', user2.email, user2.handle, 'password', 'password')
    expect(page).to have_content 'Emailduplicate email'
    expect(page).to have_content 'Handleduplicate handle'
  end
end

def login_with(email, password, remember_me)
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  check 'session_remember_me' if remember_me
  click_button 'Log in'
end

def update_to(name, email, handle, password, password_confirmation)
  fill_in 'Name', with: name
  fill_in 'Email', with: email
  fill_in 'Handle', with: handle
  fill_in 'Password', with: password
  fill_in 'Password confirmation', with: password_confirmation
  click_button 'Save Profile'
end
