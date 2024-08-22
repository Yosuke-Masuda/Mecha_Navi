require 'rails_helper'

RSpec.describe 'Companyモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { company.valid? }

    let(:company) { create(:company) }
    let(:other_company) { create(:company) }

    context '登録フォーム各カラム' do
      it '空欄でないこと' do
        company.company_name = ''
        company.company_name_kana = ''
        company.postal_code = ''
        company.address = ''
        company.phone_number = ''
        company.email = ''
        is_expected.to eq false
      end
      it '空欄の場合はエラーが出る' do
        company.company_name = ''
        company.company_name_kana = ''
        company.postal_code = ''
        company.address = ''
        company.phone_number = ''
        company.email = ''
        company.valid?
        expect(company.errors[:company_name]).to include("を入力してください")
        expect(company.errors[:company_name_kana]).to include("を入力してください")
        expect(company.errors[:postal_code]).to include("を入力してください")
        expect(company.errors[:address]).to include("を入力してください")
        expect(company.errors[:phone_number]).to include("を入力してください")
        expect(company.errors[:email]).to include("を入力してください")
      end
      it '一意であること' do
        # 登録できたら失敗
        company.company_name = '株式会社テスト'
        company.company_name_kana = 'カブシキガイシャテスト'
        company.postal_code = '1234567'
        company.address = 'テスト１−２−３'
        company.phone_number = '12345678910'
        company.email = 'test@gmail.com'
        company.save
        other_company.company_name = '株式会社テスト'
        other_company.company_name_kana = 'カブシキガイシャテスト'
        other_company.postal_code = '1234567'
        other_company.address = 'テスト１−２−３'
        other_company.phone_number = '12345678910'
        other_company.email = 'test@gmail.com'
        other_company.save
        other_company.valid?
        expect(other_company).to be_invalid
      end
      it '一意でない場合はエラーが出る' do
        # company.company_name = '株式会社テスト'
        # company.company_name_kana = 'カブシキガイシャテスト'
        # company.postal_code = '1234567'
        # company.address = 'テスト１−２−３'
        # company.phone_number = '12345678910'
        company.email = 'test@gmail.com'
        company.save
        # other_company.company_name = '株式会社テスト'
        # other_company.company_name_kana = 'カブシキガイシャテスト'
        # other_company.postal_code = '1234567'
        # other_company.address = 'テスト１−２−３'
        # other_company.phone_number = '12345678910'
        other_company.email = 'test@gmail.com'
        other_company.save
        other_company.valid?
        #expect(other_company.errors[:company_name]).to include("はすでに存在します")
        #expect(other_company.errors[:company_name_kana]).to include("はすでに存在します")
        #expect(other_company.errors[:postal_code]).to include("はすでに存在します")
        #expect(other_company.errors[:address]).to include("はすでに存在します")
        #expect(other_company.errors[:phone_number]).to include("はすでに存在します")
        expect(other_company.errors[:email]).to include("はすでに存在します")
      end
    end

    # context 'bodyカラム' do
    #   it '空欄でないこと' do
    #     task.body = ''
    #     is_expected.to eq false
    #   end
    #   it '空欄の場合はエラーが出る' do
    #     task.body = ''
    #     task.valid?
    #     expect(task.errors[:body]).to include("を入力してください")
    #   end
    #   it '一意であること' do
    #     # 登録できたら失敗
    #     task.body = 'テスト'
    #     task.save
    #     other_task.body = 'テスト'
    #     other_task.save
    #     other_task.valid?
    #     expect(other_task).to be_invalid
    #   end
    #   it '一意でない場合はエラーが出る' do
    #     task.body = 'テスト'
    #     task.save
    #     other_task.body = 'テスト'
    #     other_task.save
    #     other_task.valid?
    #     expect(other_task.errors[:body]).to include("はすでに存在します")
    #   end
    # end
  end

  describe 'アソシエーションのテスト' do
    context 'Storeモデルとの関係' do
      it 'N:1となっている' do
        expect(Company.reflect_on_association(:stores).macro).to eq :has_many
      end
    end

    context 'Employeeモデルとの関係' do
      it 'N:1となっている' do
        expect(Company.reflect_on_association(:employees).macro).to eq :has_many
      end
    end

    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Company.reflect_on_association(:posts).macro).to eq :has_many
      end
    end

    context 'Genreモデルとの関係' do
      it 'N:1となっている' do
        expect(Company.reflect_on_association(:genres).macro).to eq :has_many
      end
    end

    context 'Car_nameモデルとの関係' do
      it 'N:1となっている' do
        expect(Company.reflect_on_association(:car_names).macro).to eq :has_many
      end
    end

    context 'Taskモデルとの関係' do
      it 'N:1となっている' do
        expect(Company.reflect_on_association(:tasks).macro).to eq :has_many
      end
    end
  end
end