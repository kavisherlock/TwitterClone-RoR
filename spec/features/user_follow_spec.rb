require 'rails_helper'

PARTIAL_PAGE_TITLE = ' | NotTwitter'.freeze

feature 'User following feature' do
  scenario 'Follow and Unfollow button' do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user2)
    visit login_path
    login_with(user.email, user.password, false)
    visit "/users/#{user2.id}"
    expect(page).to have_css 'a', text: '0 Followers'
    click_button 'Follow'
    expect(page).to have_css 'a', text: '1 Followers'
    click_button 'Unfollow'
    expect(page).to have_css 'a', text: '0 Followers'
  end

  scenario 'Updates the following count' do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user2)
    visit login_path
    login_with(user.email, user.password, false)
    visit "/users/#{user.id}"
    expect(page).to have_css 'a', text: '0 Following'
    visit "/users/#{user2.id}"
    click_button 'Follow'
    visit "/users/#{user.id}"
    expect(page).to have_css 'a', text: '1 Following'
  end

  scenario 'Seeing tweats from user you follow' do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user2)
    tweat = FactoryGirl.create(:tweat)
    visit login_path
    login_with(user2.email, user2.password, false)
    visit "/users/#{user.id}"
    click_button 'Follow'
    visit home_path
    expect(page).to have_css 'a', text: user.name.to_s
    expect(page).to have_css 'div', text: tweat.content.to_s
  end
end
