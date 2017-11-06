require 'rails_helper'

PARTIAL_PAGE_TITLE = ' | NotTwitter'.freeze

feature 'Tweating from the profile page' do
  scenario 'User tweat shows on page' do
    user = FactoryGirl.create(:user)
    visit login_path
    login_with(user.email, user.password, false)
    visit "/users/#{user.id}"
    tweat('content')
    expect(page).to have_css '.tweat'
    expect(page).to have_css '.user a', text: user.name
    expect(page).to have_css '.content', text: 'content'
    expect(page).to have_css '.timestamp',
                             text: 'Posted less than a minute ago.'
    expect(page).to have_css 'a', text: 'Delete'
  end

  scenario 'User deletes tweat' do
    user = FactoryGirl.create(:user)
    visit login_path
    login_with(user.email, user.password, false)
    visit "/users/#{user.id}"
    tweat('content')
    click_link 'Delete'
    expect(page).to_not have_css '.tweat'
  end
end

feature 'Tweating from the Home page' do
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
    expect(page).to have_css 'p', text: "@#{user.handle}"
  end

  scenario 'User tweats through home page' do
    user = FactoryGirl.create(:user)
    visit login_path
    login_with(user.email, user.password, false)
    visit home_path
    tweat('content')
    expect(page).to have_css '.tweat'
    expect(page).to have_css '.user a', text: user.name
    expect(page).to have_css '.content', text: 'content'
    expect(page).to have_css '.timestamp',
                             text: 'Posted less than a minute ago.'
    expect(page).to have_css 'a', text: 'Delete'
  end

  scenario 'User deletes tweat' do
    user = FactoryGirl.create(:user)
    visit login_path
    login_with(user.email, user.password, false)
    visit home_path
    tweat('content')
    click_link 'Delete'
    expect(page).to_not have_css '.tweat'
  end
end

def tweat(content)
  fill_in 'tweat_content', with: content
  click_button 'Post'
end
