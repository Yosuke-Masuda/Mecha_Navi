require 'rails_helper'

describe '[STEP3] 社員ログイン後のテスト' do
  let(:company) { create(:company) }
  let!(:car_name) { create(:car_name, company: company) }
  let!(:store) { create(:store, company: company) }
  let!(:genre) { create(:genre, company: company) }
  let!(:employee) { create(:employee, company: company) }
  let!(:post) { create(:post, company: company, employee: employee, car_name: car_name, store: store, genre: genre) }

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

  describe 'マイページ画面のテスト' do
    before do
      visit mypage_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/employees/mypage'
      end
      it "お気に入りのリンク先が正しい" do
        expect(page).to have_link '', href: favorites_mypage_path
      end
      it "編集ボタンのリンク先が正しい" do
        expect(page).to have_link '', href: edit_mypage_path
      end
      it "投稿履歴ボタンのリンク先が正しい" do
        expect(page).to have_link '', href: history_mypage_path
      end
      it "変更ボタン（パスワード）のリンク先が正しい" do
        expect(page).to have_link '', href: edit_employee_registration_path
      end
    end

    context 'マイページ画面のテスト' do
      it 'お気に入りボタンをクリックするとお気に入り画面へ遷移する' do
        click_link "お気に入り"
        expect(current_path).to eq favorites_mypage_path
      end
      it '編集ボタンをクリックするとマイページ編集画面へ遷移する' do
        click_link '編集'
        expect(current_path).to eq edit_mypage_path
      end
      it '投稿履歴ボタンをクリックすると投稿履歴画面へ遷移する' do
        click_link '投稿履歴'
        expect(current_path).to eq history_mypage_path
      end
      it '変更ボタンをクリックするとパスワード変更画面へ遷移する' do
        click_link '変更'
        expect(current_path).to eq edit_employee_registration_path
      end
    end
  end

  describe 'マイページ編集画面のテスト' do
    before do
      visit edit_mypage_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/employees/mypage/edit'
      end
      it '店舗名が表示される' do
        expect(page).to have_content(employee.store.name)
      end
      it '画像選択ファイルが表示されること' do
        expect(page).to have_selector("img")
      end
      it '姓と名が正しく表示されること' do
        expect(page).to have_field('employee_last_name')
        expect(page).to have_field('employee_first_name')
      end
      it 'セイとメイが正しく表示されること' do
        expect(page).to have_field('employee_last_name_kana')
        expect(page).to have_field('employee_first_name_kana')
      end
      it 'メールアドレスが正しく表示されること' do
        expect(page).to have_field('employee_email')
      end
      it '保存、戻るボタンが存在すること' do
        expect(page).to have_button('保存')
        expect(page).to have_link('', href: mypage_path)
      end
      it '戻るボタンを押すとマイページ画面へ遷移する' do
        click_link '戻る'
        expect(current_path).to eq mypage_path
      end
    end

    context '社員編集のテスト' do
      before do
        employee = FactoryBot.create(:employee)
        @employee_old_last_name = employee.last_name
        @employee_old_first_name = employee.first_name
        @employee_old_last_name_kana = employee.last_name_kana
        @employee_old_first_name_kana = employee.first_name_kana
        @employee_old_email = employee.email
        attach_file 'employee[image]', Rails.root.join("spec/support/images/no_image.jpg")
        fill_in 'employee[last_name]', with: Gimei.name.last.kanji
        fill_in 'employee[first_name]', with: Gimei.name.first.kanji
        fill_in 'employee[last_name_kana]', with: Gimei.name.last.katakana
        fill_in 'employee[first_name_kana]', with: Gimei.name.first.katakana
        fill_in 'employee[email]', with: Faker::Internet.email
        find(:xpath, all('button')[2].path).click
      end

      it 'last_nameが正しく更新される' do
        expect(employee.reload.last_name).not_to eq @employee_old_last_name
      end
      it 'first_nameが正しく更新される' do
        expect(employee.reload.first_name).not_to eq @employee_old_first_name
      end
      it 'last_name_kanaが正しく更新される' do
        expect(employee.reload.last_name_kana).not_to eq @employee_old_last_name_kana
      end
      it 'first_name_kanaが正しく更新される' do
        expect(employee.reload.first_name_kana).not_to eq @employee_old_first_name_kana
      end
      it 'emailが正しく更新される' do
        expect(employee.reload.email).not_to eq @employee_old_email
      end
      it 'リダイレクト先が、更新したマイページ画面になっている' do
        expect(current_path).to eq mypage_path
      end
    end
  end

  describe 'パスワード変更画面のテスト' do
    before do
      visit edit_employee_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/employees/edit'
      end
      it 'メールアドレスが正しく表示されること' do
        expect(page).to have_field('employee_email')
      end
      it '現在のパスワード入力フォームが表示されること' do
        expect(page).to have_field('employee_current_password')
      end
      it '新しいパスワード入力フォームが表示されること' do
        expect(page).to have_field('employee_password')
      end
      it '確認用パスワード入力フォームが表示されること' do
        expect(page).to have_field('employee_password_confirmation')
      end
      it "変更ボタン（パスワード）のリンク先が正しい" do
        expect(page).to have_link '', href: employee_registration_path
      end
    end

     context '社員パスワード変更のテスト' do
      before do
        employee = FactoryBot.create(:employee)
        fill_in 'employee[current_password]', with: employee.password
        fill_in 'employee[password]', with: Faker::Internet.password(min_length: 6)
        fill_in 'employee[password_confirmation]', with: Faker::Internet.password(min_length: 6)
        click_button '変更する'
      end

      it 'パスワードがが正しく更新される' do
        expect(employee.reload.password).not_to eq current_path
      end
    end
  end



end