require 'rails_helper'

RSpec.describe 'Taskモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { task.valid? }

    let(:company) { create(:company) }
    let!(:task) { build(:task, company_id: company.id) }
    let!(:other_task) { create(:task, company_id: company.id) }

    context 'nameカラム' do
      it '空欄でないこと' do
        task.name = ''
        is_expected.to eq false
      end
      it '空欄の場合はエラーが出る' do
        task.name = ''
        task.valid?
        expect(task.errors[:name]).to include("を入力してください")
      end
      it '一意であること' do
        # 登録できたら失敗
        task.name = 'タスク１'
        task.save
        other_task.name = 'タスク１'
        other_task.save
        other_task.valid?
        expect(other_task).to be_invalid
      end
      it '一意でない場合はエラーが出る' do
        task.name = 'タスク１'
        task.save
        other_task.name = 'タスク１'
        other_task.save
        other_task.valid?
        expect(other_task.errors[:name]).to include("はすでに存在します")
      end
    end

    context 'bodyカラム' do
      it '空欄でないこと' do
        task.body = ''
        is_expected.to eq false
      end
      it '空欄の場合はエラーが出る' do
        task.body = ''
        task.valid?
        expect(task.errors[:body]).to include("を入力してください")
      end
      it '一意であること' do
        # 登録できたら失敗
        task.body = 'テスト'
        task.save
        other_task.body = 'テスト'
        other_task.save
        other_task.valid?
        expect(other_task).to be_invalid
      end
      it '一意でない場合はエラーが出る' do
        task.body = 'テスト'
        task.save
        other_task.body = 'テスト'
        other_task.save
        other_task.valid?
        expect(other_task.errors[:body]).to include("はすでに存在します")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Companyモデルとの関係' do
      it 'N:1となっている' do
        expect(Task.reflect_on_association(:company).macro).to eq :belongs_to
      end
    end

    context 'Employeeモデルとの関係' do
      it 'N:1となっている' do
        expect(Task.reflect_on_association(:daily_tasks).macro).to eq :has_many
      end
    end
  end
end