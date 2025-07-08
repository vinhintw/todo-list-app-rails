require 'rails_helper'

RSpec.feature 'Task Management', type: :feature do
  # create user
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:task) { create(:task, user: user, title: 'Original Title', content: 'Original content') }

  before do
    # login
    visit login_path
    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: user.password
    click_button 'Sign in'
  end

  # create a task
  context 'Creating a task' do
    before do
      visit new_task_path
      fill_in 'Title', with: 'My first task'
      click_button 'Create Task'
    end

    it 'User can create a simple task' do
      expect(page).to have_content('Task was successfully created')
      expect(page).to have_content('My first task')
    end
  end

  # Test validation
  describe 'Validation' do
    context 'when creating a task with invalid data' do
      before do
        visit new_task_path

        # Leave title blank
        click_button 'Create Task'
      end

      it 'User cannot create task without title' do
        expect(page).to have_content("Title can't be blank")
      end
    end
  end

  # Test viewing tasks
  describe 'Viewing tasks' do
    context 'when user has tasks' do
      before do
        # create tasks for the user
        create(:task, user: user, title: 'Task One')
        create(:task, user: user, title: 'Task Two')

        visit tasks_path
      end

      it 'User can view their tasks list' do
        expect(page).to have_content('Task One')
        expect(page).to have_content('Task Two')
      end
    end
  end

  # Test editing tasks
  describe 'Editing tasks' do
    context 'when user edits their own task' do
      before do
        visit tasks_path

        click_link 'Edit'

        fill_in 'Title', with: 'Updated Title'
        fill_in 'Content', with: 'Updated content'
        click_button 'Update Task'
      end

      it 'User can edit their own task via index page' do
        expect(page).to have_content('Task was successfully updated')
        expect(page).to have_content('Updated Title')
        expect(page).to have_content('Updated content')
      end
    end

    context 'when user edits a task with invalid data' do
      before do
        visit edit_task_path(task)
        fill_in 'Title', with: ''
        click_button 'Update Task'
      end
      it 'User cannot update task without title' do
        expect(page).to have_content("Title can't be blank")
      end
    end
  end

  # Test viewing task details
  describe 'Viewing task details' do
    context 'when user has tasks and clicks on a task' do
      let!(:task) do
        create(:task,
        user: user,
        title: 'Detailed Task',
        content: 'This is the detailed content of the task',
        priority: 'high',
        status: 'pending'
        )
      end

      before do
        visit tasks_path
      end

      it 'User can view task details from index page' do
        expect(page).to have_content('Detailed Task')
      end

      before do
        click_link 'Detailed Task'
      end

      it 'User can view task details' do
        expect(page).to have_current_path(task_path(task))
        expect(page).to have_content('Detailed Task')
        expect(page).to have_content('This is the detailed content of the task')
        expect(page).to have_content('Showing task')

        expect(page).to have_link('Edit this task')
        expect(page).to have_link('Back to tasks')
        expect(page).to have_button('Destroy this task')
      end
    end
  end

  # Test deleting tasks from index page
  describe 'Deleting tasks' do
    context 'when user deletes their own task from index page' do
      let!(:task) do
        create(:task,
          user: user,
          title: 'Task to Delete',
          content: 'This will be deleted'
        )
      end

      before do
        visit tasks_path
      end

      it 'User can see their own task from index page' do
        expect(page).to have_content('Task to Delete')
      end

      context 'after clicking delete button' do
        before do
          click_button 'Delete'
        end

        it 'User sees confirmation and task is removed' do
          expect(page).to have_content('Task was successfully destroyed')
          expect(page).not_to have_content('Task to Delete')
          expect(page).to have_current_path(tasks_path)
        end
      end
    end
  end

  # Test deleting from detail page
  describe 'Deleting tasks from detail page' do
    context 'when user deletes their own task from show page' do
      let!(:task) do
        create(:task,
          user: user,
          title: 'Task to Delete from Show',
          content: 'Will be deleted'
        )
      end

      before do
        visit task_path(task)
      end

      it 'User can see the task details' do
        expect(page).to have_content('Task to Delete from Show')
        expect(page).to have_content('Will be deleted')
      end

      context 'after clicking destroy button' do
        before do
          click_button 'Destroy this task'
        end

        it 'User sees confirmation and task is removed' do
          expect(page).to have_content('Task was successfully destroyed')
          expect(page).to have_current_path(tasks_path)
          expect(page).not_to have_content('Task to Delete from Show')
        end
      end
    end
  end
end
