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

      it 'マイページを押すと、社員詳細画面に遷移する' do
        home_link = find_all('a')[2].native.inner_text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/employees/mypage'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        home_link = find_all('a')[3].native.inner_text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/about'
      end
      it 'サービスのドロップダウンで社員一覧を押すと、社員一覧画面へ遷移する' do
        employee_link = find_all('a')[5].native.inner_text
        employee_link = employee_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link employee_link
        is_expected.to eq '/employees'
      end
      it 'サービスのドロップダウンで新規投稿を押すと、新規投稿画面へ遷移する' do
        post_link = find_all('a')[6].native.inner_text
        post_link = post_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link post_link
        is_expected.to eq '/posts/new'
      end
      it 'サービスのドロップダウンで投稿一覧を押すと、投稿一覧画面へ遷移する' do
        post_link = find_all('a')[7].native.inner_text
        post_link = post_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link post_link
        is_expected.to eq '/posts'
      end
      it 'サービスのドロップダウンでタスクカレンダーを押すと、タスクカレンダー画面へ遷移する' do
        post_link = find_all('a')[8].native.inner_text
        post_link = post_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link post_link
        is_expected.to eq '/employees/' + employee.id.to_s + '/tasks'
      end
    end
  end
  
  describe 'マイページのテスト' do
    before do
      visit mypage_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/employees/mypage'
      end
    end
  end

end