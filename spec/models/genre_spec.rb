require 'rails_helper'

RSpec.describe 'Genreモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { genre.valid? }

    let(:company) { create(:company) }
    let!(:genre) { build(:genre, company_id: company.id) }
    let!(:other_genre) { create(:genre, company_id: company.id) }
    #let!(:post) {build(:post, company_id: company.id, employee_id: employee.id) }

    context 'nameカラム' do
      it '空欄でないこと' do
        genre.name = ''
        is_expected.to eq false
      end
      it '空欄の場合はエラーが出る' do
        genre.name = ''
        genre.valid?
        expect(genre.errors[:name]).to include("を入力してください")
      end
      it '一意であること' do
        # 登録できたら失敗
        genre.name = 'エンジン'
        genre.save
        other_genre.name = 'エンジン'
        other_genre.save
        other_genre.valid?
        expect(other_genre).to be_invalid
      end
      it '一意でない場合はエラーが出る' do
        genre.name = 'エンジン'
        genre.save
        other_genre.name = 'エンジン'
        other_genre.save
        other_genre.valid?
        expect(other_genre.errors[:name]).to include("はすでに存在します")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Companyモデルとの関係' do
      it 'N:1となっている' do
        expect(Genre.reflect_on_association(:company).macro).to eq :belongs_to
      end
    end

    # context 'Employeeモデルとの関係' do
    #   it 'N:1となっている' do
    #     expect(Genre.reflect_on_association(:employee).macro).to eq :has_many
    #   end
    # end

    # context 'Postモデルとの関係' do
    #   it 'postsとの関連付け正しく設定されていること' do
    #   # genreと関連付けされたpostを作成
    #   post = FactoryBot.create(:post)
    #   # 「@user.shop_saved_lists」を実行したときに、作成したリストを含んでいるかを確認
    #   expect(genre.id.posts).to include post
    # end
    #   it 'N:1となっている' do
    #     expect(Genre.reflect_on_association(:post).macro).to eq :has_many
    #   end
    # end
  end
end