require 'rails_helper'

LOGIN_PAGE_TITLE = 'Log in | NotTwitter'.freeze

feature 'Log in page' do
  scenario 'Log in form' do
    visit '/login'
    expect(page).to have_title LOGIN_PAGE_TITLE
    expect(page).to have_css 'img', class: 'logo'
    expect(page).to have_css 'h1', text: 'WELCOME'
    expect(page).to have_css 'h1', text: 'TO'
    expect(page).to have_css 'h1', text: 'NOT TWITTER'
    expect(page).to have_css 'p', text: 'Just like Twitter, but not Twitter'
    expect(page).to have_css 'h1', text: 'Log in'
    expect(page).to have_css 'label', text: 'Email'
    expect(page).to have_css 'input', id: 'session_email'
    expect(page).to have_css 'label', text: 'Password'
    expect(page).to have_css 'input', id: 'session_password'
    expect(page).to have_css 'a', text: '(Forgot Password?)'
    expect(page).to have_css 'label', text: 'Remember me'
    expect(page).to have_css 'input', id: 'session_remember_me'
    expect(page).to have_css 'input', class: 'login-button'
    expect(page).to have_css 'a', text: 'Not a member yet? Sign up now!'
  end

  scenario 'Successful log in' do
    user = FactoryGirl.create(:user)
    login_with(user.email, user.password, false)
    expect(current_path).to eql(home_path)
    expect(page).to have_content 'Welcome ' + user.name + '!!'
  end

  scenario 'Bad email' do
    user = FactoryGirl.create(:user)
    login_with('bad email', user.password, false)
    expect(page).to have_content 'Invalid email/password combination'
  end

  scenario 'Bad password' do
    user = FactoryGirl.create(:user)
    login_with(user.email, 'bad password', false)
    expect(page).to have_content 'Invalid email/password combination'
  end

  scenario 'Remember me saves cookies' do
    user = FactoryGirl.create(:user)
    login_with(user.email, user.password, true)
    expect(page).to have_content 'Welcome ' + user.name + '!!'
    expect(Capybara.current_session.driver.request.cookies.[]('user_id'))
      .to_not be_nil
    expect(Capybara.current_session.driver.request.cookies.[]('remember_token'))
      .to_not be_nil
  end

  scenario 'Sign up button' do
    visit '/login'
    click_link 'Not a member yet? Sign up now!'
    expect(current_path).to eql(signup_path)
  end

  scenario 'Successful log out' do
    user = FactoryGirl.create(:user)
    login_with(user.email, user.password, false)
    expect(current_path).to eql(home_path)
    click_link 'Account'
    click_link 'Log out'
    expect(current_path).to eql(login_path)
  end

  def login_with(email, password, remember_me)
    visit login_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    check 'session_remember_me' if remember_me
    click_button 'Log in'
  end
end
