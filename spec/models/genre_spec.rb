require 'rails_helper'

RSpec.describe 'Genreモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { genre.valid? }

    let(:company) { create(:company) }
    let!(:genre) { build(:genre, company_id: company.id) }
    let!(:other_genre) { create(:genre, company_id: company.id) }

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

    context 'Employeeモデルとの関係' do
      it 'N:1となっている' do
        expect(Genre.reflect_on_association(:employees).macro).to eq :has_many
      end
    end

    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Genre.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
  end
end