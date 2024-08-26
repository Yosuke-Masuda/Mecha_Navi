require "rails_helper"

RSpec.describe "CarNameモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { car_name.valid? }

    let(:company) { create(:company) }
    let!(:car_name) { build(:car_name, company_id: company.id) }
    let!(:other_car_name) { create(:car_name, company_id: company.id) }

    context "各カラム" do
      it "空欄でないこと" do
        car_name.name = ""
        car_name.car_type = ""
        is_expected.to eq false
      end
      it "空欄の場合はエラーが出る" do
        car_name.name = ""
        car_name.car_type = ""
        car_name.valid?
        expect(car_name.errors[:name]).to include("を入力してください")
        expect(car_name.errors[:car_type]).to include("を入力してください")
      end
      # it '一意であること' do
      #   # 登録できたら失敗
      #   car_name.car_type = 'DAA-DE6'
      #   car_name.save
      #   other_car_name.car_type = 'DAA-GE6'
      #   other_car_name.save
      #   other_car_name.valid?
      #   expect(other_car_type).to be_invalid
      # end
      # it '一意でない場合はエラーが出る' do
      #   car_name.car_type = 'DAA-GE6'
      #   car_name.save
      #   other_car_name.name = 'DAA-GE6'
      #   other_car_name.save
      #   other_car_name.valid?
      #   expect(other_car_name.errors[:car_type]).to include("はすでに存在します")
      # end
    end
  end

  describe "アソシエーションのテスト" do
    context "Companyモデルとの関係" do
      it "N:1となっている" do
        expect(CarName.reflect_on_association(:company).macro).to eq :belongs_to
      end
    end

    context "Employeeモデルとの関係" do
      it "N:1となっている" do
        expect(CarName.reflect_on_association(:employees).macro).to eq :has_many
      end
    end

    context "Postモデルとの関係" do
      it "N:1となっている" do
        expect(CarName.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
  end
end
