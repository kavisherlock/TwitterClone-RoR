require 'rails_helper'

PARTIAL_PAGE_TITLE = ' | NotTwitter'.freeze

feature 'Home Page' do
  scenario 'Login page if user is not logged in' do
    visit home_path
    expect(current_path).to eql(login_path)
  end

  scenario 'User info if user is logged in' do
    user = FactoryGirl.create(:user)
    visit login_path
    login_with(user.email, user.password, false)
    visit home_path
    expect(page).to have_title "Home#{PARTIAL_PAGE_TITLE}"
    expect(page).to have_css 'h1', text: user.name
    expect(page).to have_css 'p', text: "@#{user.handle}"
  end
end

feature 'About Page' do
  scenario 'Shows static elements' do
    visit about_path
    expect(page).to have_title "About#{PARTIAL_PAGE_TITLE}"
    expect(page).to have_css 'h1', text: 'About'
    expect(page).to have_css 'p', text: 'NotTwitter is'
    expect(page).to have_css 'h2', text: 'what’s happening in the world.'
    expect(page).to have_css 'p', text: 'See'
    expect(page).to have_css 'h2', text: 'what people are saying.'
    expect(page).to have_css 'p', text: 'Start'
    expect(page).to have_css 'h2', text: 'a global conversaion.'
    expect(page).to have_css 'p', text: 'Follow'
    expect(page).to have_css 'h2', text: 'those who inspire you.'
    expect(page).to have_css 'p', text: 'Inspire'
    expect(page).to have_css 'h2', text: 'others.'
  end

  scenario 'Sign up button if user is not logged in' do
    visit about_path
    expect(page).to have_css 'p', text: 'Join us now'
    expect(page).to have_css 'a', text: 'Not Twitter'
  end

  scenario 'Home button if user is logged in' do
    user = FactoryGirl.create(:user)
    visit login_path
    login_with(user.email, user.password, false)
    visit about_path
    expect(page).to have_css 'p', text: 'Be part of something bigger'
    expect(page).to have_css 'a', text: 'Home'
  end
end

feature 'Help Page' do
  scenario 'Shows static elements' do
    visit help_path
    expect(page).to have_title "Help#{PARTIAL_PAGE_TITLE}"
    expect(page).to have_css 'h1', text: 'Help'
    expect(page).to have_css 'h3', text: 'Source Code'
    expect(page).to have_css 'a', text: 'Github Link'
    expect(page).to have_css 'h3', text: 'Contact Us'
  end
end

feature 'Contact Us Page' do
  scenario 'Shows static elements' do
    visit contact_path
    expect(page).to have_title "Contact Us#{PARTIAL_PAGE_TITLE}"
    expect(page).to have_css 'h1', text: 'Contact Us'
    expect(page).to have_css 'img'
    expect(page).to have_css 'h2', text: 'Kavish R. Munjal'
    expect(page).to have_css 'h4', text: 'Owner and maintaner'
    expect(page).to have_css 'h3', text: 'kavish@twitter.com'
    expect(page).to have_css 'p', text: 'Address: yeah, I don\'t think so'
    expect(page).to have_css 'p', text: 'Phone: not very secure'
    expect(page).to have_css 'p', text: 'SSN: you\'re kidding right?'
  end
end

def login_with(email, password, remember_me)
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  check 'session_remember_me' if remember_me
  click_button 'Log in'
end
