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

  # Test validation
  describe 'Validation' do
    scenario 'User cannot create task without title' do
      visit '/tasks/new'

      # Leave title blank
      click_button 'Create Task'

      expect(page).to have_content("Title can't be blank")
    end
  end

  # Test viewing tasks
  describe 'Viewing tasks' do
    scenario 'User can view their tasks list' do
      # create tasks for the user
      create(:task, user: user, title: 'Task One')
      create(:task, user: user, title: 'Task Two')

      visit '/tasks'

      expect(page).to have_content('Task One')
      expect(page).to have_content('Task Two')
    end

    scenario 'User should only see their own tasks' do
      # Create task for the current user
      create(:task, user: user, title: 'My Task')

      # Create task for another user
      other_user = create(:user)
      create(:task, user: other_user, title: 'Other User Task')

      visit '/tasks'

      expect(page).to have_content('My Task')
      expect(page).not_to have_content('Other User Task')
    end
  end
end
