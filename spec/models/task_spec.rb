require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  describe "validations" do
    context "when creating a task" do
      let(:task) { Task.new(
        title: "Test Title",
        content: "Test content",
        start_time: DateTime.now,
        end_time: DateTime.now + 1.hour,
        user: user
      )}
      it { expect(task).to be_valid }
    end

    context "when leave blank title" do
      let(:task) { Task.new(
        content: "Test content",
        start_time: DateTime.now,
        end_time: DateTime.now + 1.hour,
        user: user
      )}
      it { expect(task).to_not be_valid }
    end

    context "when start_time is before end_time" do
      let(:task) { Task.new(
        content: "Test content",
        start_time: DateTime.now,
        end_time: DateTime.now + 1.hour,
        user: user
      )}
      it { expect(task).to_not be_valid }
    end

    context "when end_time is before start_time" do
      let(:task) { Task.new(
        title: "Test Title",
        content: "Test content",
        start_time: DateTime.now,
        end_time: DateTime.now - 1.hour,
        user: user
      )}
      it { expect(task).to_not be_valid }
    end

    context "when title is over 255 characters" do
      let(:task) { Task.new(
        title: "a" * 256,
        content: "Test content",
        start_time: DateTime.now,
        end_time: DateTime.now + 1.hour,
        user: user
      )}
      it { expect(task).to_not be_valid }
    end

    context "when content is over 5000 characters" do
      let(:task) { Task.new(
        title: "Test Title",
        content: "a" * 5001,
        start_time: DateTime.now,
        end_time: DateTime.now + 1.hour,
        user: user
      )}
      it { expect(task).to_not be_valid }
    end

    context "when user is not present" do
      let(:task) { Task.new(
        title: "Test Title",
        content: "Test content",
        start_time: DateTime.now,
        end_time: DateTime.now + 1.hour
      )}
      it { expect(task).to_not be_valid }
    end
  end

  describe 'search filtering tasks' do
    let!(:task1) { create(:task, :in_progress, user: user, title: 'Task 1') }
    let!(:task2) { create(:task, :completed, user: user, title: 'Task 2') }
    let!(:task3) { create(:task, :cancelled, user: user, title: 'Different') }
    let(:title_params) { { title: 'Task' } }

    context 'when searching tasks with title condition' do
      let(:q) { user.tasks.ransack(title_cont: title_params[:title]) }
      before do
        q.result
      end

      it { expect(q.result).to include(task1, task2) }
      it { expect(q.result).not_to include(task3) }
    end

    context 'when searching tasks with status condition' do
      let(:q) { user.tasks.ransack(status_eq: Task.statuses[:in_progress]) }
      before do
        q.result
      end

      it { expect(q.result).to include(task1) }
      it { expect(q.result).not_to include(task2, task3) }
    end
  end
end
