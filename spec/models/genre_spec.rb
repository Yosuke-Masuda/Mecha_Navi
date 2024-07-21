require 'rails_helper'
	 
RSpec.describe Genre, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効なジャンル名の場合は保存されるか" do
      expect(FactoryBot.build(:genre)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      book = Genre.new(name: '')
      expect(book).to be_invalid
      expect(book.errors[:name]).to include("can't be blank")
    end
  end
end