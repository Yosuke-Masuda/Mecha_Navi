require 'rails_helper'

describe 'employeeのテスト' do
  let!(:employee) { create(:employee) }

  describe "edit_mypage_path のテスト" do
    subject { visit edit_mypage_path }

    context "ログインしている場合" do
      before do
        #visit new_employee_session_path
        #fill_in 'employee[email]', with: employee.email
        #fill_in 'employee[password]', with: employee.password
        #click_button 'ログイン'

        sign_in employee
      end

      it "edit_mypage_path に行ける" do
        subject
        expect(current_path).to eq("/employees/mypage/edit")
      end
    end

    context "ログインしていない場合" do
      it "edit_mypage_path に行けない" do
        subject
        expect(current_path).to eq("/employees/sign_in")
      end
    end
  end
end

describe 'companyのテスト' do
  let!(:company) { create(:company) }
  let!(:post) { create(:post, employee: employee) }
  
  before do
    sign_in company
  end
  
  context "社員が企業に所属している場合" do
    let!(:employee) { create(:employee, company: company) }
    it "削除" do
      visit 投稿を削除するパス
      expect(Post.count).to eq(0)
    end
  end
  
  context "社員が企業に所属していない場合" do
    let!(:employee) { create(:employee) }
    it "削除" do
      visit 投稿を削除するパス
      expect(Post.count).to eq(1)
    end
  end
end