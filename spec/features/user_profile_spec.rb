require 'rails_helper'

PARTIAL_PAGE_TITLE = ' | NotTwitter'.freeze

feature 'User Profile page' do
  scenario 'User info' do
    user = FactoryGirl.create(:user)
    visit "/users/#{user.id}"
    expect(page).to have_title "#{user.name}#{PARTIAL_PAGE_TITLE}"
    expect(page).to have_css 'h1', text: user.name
    expect(page).to have_css 'strong', text: 'Email:'
    expect(page).to have_css 'p', text: user.email
    expect(page).to have_css 'strong', text: 'Handle:'
    expect(page).to have_css 'p', text: user.handle
  end
end
