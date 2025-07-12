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

  describe 'test search condition of task title' do
    let!(:task1) { create(:task, user: user, title: 'Task 1') }
    let!(:task2) { create(:task, user: user, title: 'Task 2') }
    let!(:task3) { create(:task, user: user, title: 'Different') }
    let(:title_params) { { title: 'Task' } }

    before do
      @q = user.tasks.ransack(title_cont: title_params[:title])
    end

    it 'returns tasks that match the title condition' do
      expect(@q.result).to include(task1, task2)
      expect(@q.result).not_to include(task3)
    end

    it 'does not return tasks that do not match the title condition' do
      expect(@q.result).not_to include(task3)
    end
  end
end
