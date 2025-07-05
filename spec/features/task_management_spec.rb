require 'rails_helper'

RSpec.feature 'Task Management', type: :feature do
  # create user
  let(:user) { create(:user) }

  before do
    # login
    visit '/login'
    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: 'password123'
    click_button 'Sign in'
  end

  # create a task
  describe 'Creating a task' do
    scenario 'User can create a simple task' do
      visit '/tasks/new'

      fill_in 'Title', with: 'My first task'
      click_button 'Create Task'

      expect(page).to have_content('Task was successfully created')
      expect(page).to have_content('My first task')
    end
  end
end
