require 'rails_helper'

describe Role, type: :model do
  describe 'associations' do
    let(:assoc) { described_class.reflect_on_association(:users) }
    it { expect(assoc.macro).to eq :has_many }
    it { expect(assoc.options[:dependent]).to eq :restrict_with_exception }
  end

  describe 'validations' do
    let!(:admin_role) { Role.create(name: 'admin') }
    let(:duplicate_role) { Role.create(name: 'admin') }
    let(:blank_role) { Role.new(name: nil) }
    it { expect(blank_role.valid?).to be false }
    it { expect(duplicate_role.valid?).to be false }
  end

  describe 'constants' do
    it { expect(Role::ADMIN).to eq('admin') }
    it { expect(Role::USER).to eq('user') }
  end

  describe '#admin?' do
    let(:role) { Role.new(name: 'admin') }
    let(:non_admin_role) { Role.new(name: 'user') }
    it { expect(role.admin?).to be true }
    it { expect(role.user?).to be false }
    it { expect(non_admin_role.admin?).to be false }
    it { expect(non_admin_role.user?).to be true }
  end
end
