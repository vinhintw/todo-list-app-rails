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

  # Test editing tasks
  describe 'Editing tasks' do
    scenario 'User can edit their own task via index page' do
      create(:task, user: user, title: 'Original Title', content: 'Original content')

      visit '/tasks'
      expect(page).to have_content('Original Title')

      click_link 'Edit'

      # change title and content
      fill_in 'Title', with: 'Updated Title'
      fill_in 'Content', with: 'Updated content'
      click_button 'Update Task'

      expect(page).to have_content('Task was successfully updated')
      expect(page).to have_content('Updated Title')
      expect(page).to have_content('Updated content')
    end

    scenario 'User cannot update task without title' do
      task = create(:task, user: user, title: 'Original Title')

      visit "/tasks/#{task.id}/edit"
      fill_in 'Title', with: ''
      click_button 'Update Task'

      expect(page).to have_content("Title can't be blank")
    end
  end

  # Test viewing task details
  describe 'Viewing task details' do
    scenario 'User can view task details via show page' do
      task = create(:task,
        user: user,
        title: 'Detailed Task',
        content: 'This is the detailed content of the task',
        priority: 'high',
        status: 'pending'
      )

      visit '/tasks'
      expect(page).to have_content('Detailed Task')

      click_link 'Detailed Task'

      expect(page).to have_current_path("/tasks/#{task.id}")
      expect(page).to have_content('Detailed Task')
      expect(page).to have_content('This is the detailed content of the task')
      expect(page).to have_content('Showing task')

      expect(page).to have_link('Edit this task')
      expect(page).to have_link('Back to tasks')
      expect(page).to have_button('Destroy this task')
    end
  end

  # Test deleting tasks from index page
  describe 'Deleting tasks' do
    scenario 'User can delete their own task via index page' do
      create(:task, user: user, title: 'Task to Delete', content: 'This will be deleted')

      visit '/tasks'
      expect(page).to have_content('Task to Delete')

      click_button 'Delete'

      expect(page).to have_content('Task was successfully destroyed')
      expect(page).not_to have_content('Task to Delete')
      expect(page).to have_current_path('/tasks')
    end
  end

  # Test deleting from detail page
  describe 'Deleting tasks from detail page' do
    scenario 'User can delete their own task from show page' do
      task = create(:task, user: user, title: 'Task to Delete from Show', content: 'Will be deleted')

      visit "/tasks/#{task.id}"
      expect(page).to have_content('Task to Delete from Show')
      expect(page).to have_content('Will be deleted')

      click_button 'Destroy this task'

      expect(page).to have_content('Task was successfully destroyed')
      expect(page).to have_current_path('/tasks')
      expect(page).not_to have_content('Task to Delete from Show')
    end
  end
end
