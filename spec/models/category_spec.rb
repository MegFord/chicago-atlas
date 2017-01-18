require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "Factory validation check" do
    context "valid factory" do
      it "should be valid factory" do
        expect(FactoryGirl.create(:category)).to be_valid
      end
    end

    context "invalid factory" do
      it "should be invalid without name" do
        expect(FactoryGirl.build(:category, name: nil)).not_to be_valid
      end
    end
  end

  describe "ActiveRecord associations" do
    it { should have_many(:resources) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
  end
end
