require 'rails_helper'

RSpec.feature 'Task Management', type: :feature do
  # create user
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:task) { create(:task, user: user, title: 'Original Title', content: 'Original content') }

  before do
    # login
    visit login_path
    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: user.password
    click_button I18n.t('auth.sign_in')
  end

  # create a task
  context 'Creating a task' do
    before do
      visit new_task_path
      fill_in I18n.t('tasks.task_title'), with: 'My first task'
      click_button I18n.t('tasks.create_task')
    end

    it 'User can create a simple task' do
      expect(page).to have_content(I18n.t('flash.task_created'))
      expect(page).to have_content('My first task')
    end
  end

  # Test validation
  describe 'Validation' do
    context 'when creating a task with invalid data' do
      before do
        visit new_task_path

        # Leave title blank
        click_button I18n.t('tasks.create_task')
      end

      it 'User cannot create task without title' do
        expect(page).to have_content(I18n.t('activerecord.errors.models.task.attributes.title.blank'))
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
        visit task_path(I18n.locale, id: task.id)

        click_link I18n.t("edit")

        fill_in I18n.t("tasks.task_title"), with: 'Updated Title'
        fill_in I18n.t("tasks.task_content"), with: 'Updated content'
        click_button I18n.t("tasks.update_task")
      end

      it 'User can edit their own task via index page' do
        expect(page).to have_content(I18n.t("flash.task_updated"))
        expect(page).to have_content('Updated Title')
        expect(page).to have_content('Updated content')
      end
    end

    context 'when user edits a task with invalid data' do
      before do
        visit edit_task_path(locale: I18n.locale, id: task.id)
        fill_in I18n.t("tasks.task_title"), with: ''
        click_button I18n.t("tasks.update_task")
      end
      it 'User cannot update task without title' do
        expect(page).to have_content(I18n.t('activerecord.errors.models.task.attributes.title.blank'))
      end
    end
  end

  # Test viewing task details
  describe 'Viewing task details' do
    context 'when user has tasks and clicks on a task' do
      let!(:task) do
        create(:task,
        :pending,
        user: user,
        title: 'Detailed Task',
        content: 'This is the detailed content of the task',
        priority: 'high',
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
        expect(page).to have_current_path(task_path(locale: I18n.locale, id: task.id))
        expect(page).to have_content('Detailed Task')
        expect(page).to have_content('This is the detailed content of the task')
        expect(page).to have_content(I18n.t('tasks.show_task'))

        expect(page).to have_link(I18n.t('tasks.edit_this_task'))
        expect(page).to have_link(I18n.t('tasks.back_to_tasks'))
        expect(page).to have_button(I18n.t('tasks.destroy_this_task'))
      end

      describe 'User can view task details' do
        it { expect(page).to have_content('Detailed Task') }
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
          expect(page).to have_content(I18n.t('flash.task_destroyed'))
          expect(page).not_to have_content('Task to Delete')
          expect(page).to have_current_path(tasks_path(locale: I18n.locale))
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
        visit task_path(locale: I18n.locale, id: task.id)
      end

      it 'User can see the task details' do
        expect(page).to have_content('Task to Delete from Show')
        expect(page).to have_content('Will be deleted')
      end

      context 'after clicking destroy button' do
        before do
          click_button I18n.t('tasks.destroy_this_task')
        end

        it 'User sees confirmation and task is removed' do
          expect(page).to have_content(I18n.t('flash.task_destroyed'))
          expect(page).to have_current_path(tasks_path(locale: I18n.locale))
          expect(page).not_to have_content('Task to Delete from Show')
        end
      end
    end
  end

  # Test task ordering
  describe 'Task ordering' do
    let(:task_titles) { page.all('h3 a').map(&:text) }
    let!(:low_task) { create(:task, :low_priority, user: user, title: 'Low Task (Oldest)') }
    let!(:medium_task) { create(:task, :medium_priority, user: user, title: 'Medium Task (Middle)') }
    let!(:high_task) { create(:task, :high_priority, user: user, title: 'High Task (Newest)') }

    context 'when viewing tasks ordered by priority' do
      before do
        visit tasks_path
      end


      it 'displays tasks in order of priority' do
        expect(task_titles).to eq([
          'High Task (Newest)',
          'Medium Task (Middle)',
          'Low Task (Oldest)'
        ])
      end
    end

    context 'when creating a new task' do
      let!(:new_task) { create(:task, :urgent, user: user, title: 'New Task') }

      before do
        visit tasks_path
      end

      it { expect(task_titles.first).to eq('New Task') }
    end
  end

  # Test task search
  describe 'Task search' do
    let!(:task1) { create(:task, :in_progress, user: user, title: 'Searchable Task 1') }
    let!(:task2) { create(:task, :completed, user: user, title: 'Searchable Task 2') }
    let(:nav_form) { find('#desktop-search-form') }
    let(:mobile_form) { find('#mobile-search-form') }

    context 'when searching title from desktop' do
      before do
        visit tasks_path
        within(nav_form) do
          fill_in 'title', with: task1.title
          find('input[type="submit"]').click
        end
      end
      it { expect(page).to have_content(task1.title) }
      it { expect(page).not_to have_content(task2.title) }
    end

    context 'when searching title from mobile' do
      before do
        visit tasks_path
        within(mobile_form) do
          fill_in 'title', with: task1.title
          find('input[type="submit"]').click
        end
      end
      it { expect(page).to have_content(task1.title) }
      it { expect(page).not_to have_content(task2.title) }
    end

    context 'when searching by status' do
      before do
        visit tasks_path
        click_link I18n.t('status.in_progress')
      end
      it { expect(page).to have_content(task1.title) }
      it { expect(page).not_to have_content(task2.title) }
    end
  end

  # Test status dropdown
  describe 'Status dropdown' do
    let!(:pending_task) { create(:task, :pending, user: user, title: 'Pending Task') }
    let!(:in_progress_task) { create(:task, :in_progress, user: user, title: 'In Progress Task') }
    let(:dropdown) { find('#desktop-status-filter select', wait: 10) }
    let(:mobile_dropdown) { find('#status-filter select', wait: 10) }

    context 'when selecting a status from the dropdown', js: true do
      before do
        visit tasks_path(locale: I18n.locale)
        dropdown.select(I18n.t('status.pending'))
      end

      it { expect(page).to have_content(pending_task.title) }
      it { expect(page).not_to have_content(in_progress_task.title) }
    end

    context 'when selecting a status from the mobile dropdown', js: true do
      before do
        page.driver.browser.manage.window.resize_to(375, 812)
        visit tasks_path(locale: I18n.locale)
        mobile_dropdown.select(I18n.t('status.pending'))
      end

      it { expect(page).to have_content(pending_task.title) }
      it { expect(page).not_to have_content(in_progress_task.title) }
    end
  end
end
