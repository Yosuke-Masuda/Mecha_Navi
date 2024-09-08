require "rails_helper"

RSpec.describe "Genreモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { store.valid? }

    let(:company) { create(:company) }
    let!(:store) { build(:store, company_id: company.id) }
    let!(:other_store) { create(:store, company_id: company.id) }

    context "nameカラム" do
      it "空欄でないこと" do
        store.name = ""
        is_expected.to eq false
      end
      it "空欄の場合はエラーが出る" do
        store.name = ""
        store.valid?
        expect(store.errors[:name]).to include("を入力してください")
      end
      it "一意であること" do
        # 登録できたら失敗
        store.name = "テスト"
        store.save
        other_store.name = "テスト"
        other_store.save
        other_store.valid?
        expect(other_store).to be_invalid
      end
      it "一意でない場合はエラーが出る" do
        store.name = "テスト"
        store.save
        other_store.name = "テスト"
        other_store.save
        other_store.valid?
        expect(other_store.errors[:name]).to include("はすでに存在します")
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "Companyモデルとの関係" do
      it "N:1となっている" do
        expect(Store.reflect_on_association(:company).macro).to eq :belongs_to
      end
    end

    context "Employeeモデルとの関係" do
      it "N:1となっている" do
        expect(Store.reflect_on_association(:employees).macro).to eq :has_many
      end
    end
  end
end
