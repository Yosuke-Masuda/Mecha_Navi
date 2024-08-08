require 'rails_helper'

describe '[STEP3] 社員ログイン後のテスト' do
  let!(:employee) { create(:employee) }
  #let!(:post) { create(:post, company: company, employee: employee, car_name: car_name) }

  before do
    visit new_employee_session_path
    fill_in 'employee[email]', with: employee.email
    fill_in 'employee[password]', with: employee.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'マイページを押すと、企業詳細画面に遷移する' do
        home_link = find_all('a')[2].native.inner_text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/employees/mypage'
      end
    end
  end

end