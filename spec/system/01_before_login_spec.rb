require 'rails_helper'

describe '[STEP1] ログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end

      it '正しいボタンが存在する' do
        expect(page).to have_link "", href: companies_guest_sign_in_path
        expect(page).to have_link "", href: employees_guest_sign_in_path
        expect(page).to have_link "", href: new_company_registration_path
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit '/about'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/about'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'Mecha_Naviリンクが表示される: 左上から1番目のリンクが「MechaNavi」である' do
        home_link = find_all('a')[1].native.inner_text
        expect(home_link).to match(/MechaNavi/)
      end
      it 'Aboutリンクが表示される: 左上から2番目のリンクが「About」である' do
        about_link = find_all('a')[2].native.inner_text
        expect(about_link).to match(/About/)
      end
      it '新規登録リンクが表示される: 左上から3番目のリンクが「新規登録」である' do
        signup_link = find_all('a')[3].native.inner_text
        expect(signup_link).to match(/新規登録/)
      end
      it 'ログインリンクが表示される: 左上から4番目のリンクが「企業ログイン」である' do
        login_link = find_all('a')[4].native.inner_text
        expect(login_link).to match(/企業ログイン/)
      end
      it 'ログインリンクが表示される: 左上から5番目のリンクが「社員ログイン」である' do
        login_link = find_all('a')[5].native.inner_text
        expect(login_link).to match(/社員ログイン/)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'Mecha_Naviを押すと、トップ画面に遷移する' do
        home_link = find_all('a')[1].native.inner_text
        home_link = home_link.delete(' ')
        home_link.gsub!(/\n/, '')
        click_link home_link
        is_expected.to eq '/'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[2].native.inner_text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/about'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[3].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link, match: :first
        is_expected.to eq '/companies/sign_up'
      end
      it '企業ログインを押すと、企業ログイン画面に遷移する' do
        login_link = find_all('a')[4].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link, match: :first
        is_expected.to eq '/companies/sign_in'
      end
      it '社員ログインを押すと、社員ログイン画面に遷移する' do
        login_link = find_all('a')[5].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link, match: :first
        is_expected.to eq '/employees/sign_in'
      end
    end
  end

  describe '企業新規登録のテスト' do
    before do
      visit new_company_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/sign_up'
      end
      it '「新規登録」と表示される' do
        expect(page).to have_content '登録'
      end
      it 'company_nameフォームが表示される' do
        expect(page).to have_field 'company[company_name]'
      end
      it 'company_name_kanaフォームが表示される' do
        expect(page).to have_field 'company[company_name_kana]'
      end
      it 'postal_codeフォームが表示される' do
        expect(page).to have_field 'company[postal_code]'
      end
      it 'addressフォームが表示される' do
        expect(page).to have_field 'company[address]'
      end
      it 'phone_numberフォームが表示される' do
        expect(page).to have_field 'company[phone_number]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'company[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'company[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'company[password_confirmation]'
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
    end

    context '新規登録成功のテスト' do
      # let!(:company) { create(:company) }
      before do
        fill_in 'company[company_name]', with: Faker::Company.name[0, rand(3..10)]
        fill_in 'company[company_name_kana]', with: Gimei.last.katakana[0, rand(3..10)]
        fill_in 'company[postal_code]', with: 7.times.map { rand(0..9) }.join("")
        fill_in 'company[address]', with: Faker::Address.full_address
        fill_in 'company[phone_number]', with: Faker::PhoneNumber.phone_number
        fill_in 'company[email]', with: Faker::Internet.email
        fill_in 'company[password]', with: 'password'
        fill_in 'company[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '登録' }.to (change{Company.count}).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できた企業の詳細画面になっている' do
        click_button '登録'
        expect(current_path).to eq '/companies/mypage'
      end
    end
  end

  describe '企業ログイン' do
    let(:company) { create(:company) }

    before do
      visit new_company_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/sign_in'
      end
      it '「企業ログイン」と表示される' do
        expect(page).to have_content '企業ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'company[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'company[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'company[email]', with: company.email
        fill_in 'company[password]', with: company.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインした企業のトップ画面になっている' do
        expect(current_path).to eq '/top'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'company[email]', with: ''
        fill_in 'company[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/companies/sign_in'
      end
    end
  end

  describe '社員ログイン' do
    let(:employee) { create(:employee) }

    before do
      visit new_employee_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/employees/sign_in'
      end
      it '「社員ログイン」と表示される' do
        expect(page).to have_content '社員ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'employee[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'employee[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'employee[email]', with: employee.email
        fill_in 'employee[password]', with: employee.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインした社員のトップ画面になっている' do
        expect(current_path).to eq '/'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'employee[email]', with: ''
        fill_in 'employee[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/employees/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: 企業がログインしている場合' do
    let(:company) { create(:company) }

    before do
      visit new_company_session_path
      fill_in 'company[email]', with: company.email
      fill_in 'company[password]', with: company.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'Mecha_Naviリンクが表示される: リンクが「Mecha_Navi」である' do
        home_link = find_all('a')[1].native.inner_text
        expect(home_link).to match(/MechaNavi/)
      end
      it 'マイページリンクが表示される: リンクが「マイページ」である' do
        home_link = find_all('a')[2].native.inner_text
        expect(home_link).to match(/マイページ/)
      end
      it '社員リンクが表示される: リンクが「社員」である' do
        users_link = find_all('a')[3].native.inner_text
        expect(users_link).to match(/社員/)
      end
      it 'サービスドロップダウンリンクが表示される: リンクが「サービス」である' do
        companies_link = find_all('a')[6].native.inner_text
        expect(companies_link).to match(/サービス/)
      end
      it 'ログアウトリンクが表示される: リンクが「ログアウト」である' do
        logout_link = find_all('a')[13].native.inner_text
        expect(logout_link).to match(/ログアウト/)
      end
      it 'Searchリンクが表示される: リンクが「Search」である' do
        search_link = find_all('button')[1].native.inner_text
        expect(search_link).to match(/Search/)
      end
    end
  end

  describe 'ヘッダーのテスト: 社員がログインしている場合' do
    let(:employee) { create(:employee) }

    before do
      visit new_employee_session_path
      fill_in 'employee[email]', with: employee.email
      fill_in 'employee[password]', with: employee.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'Mecha_Naviリンクが表示される: リンクが「Mecha_Navi」である' do
        home_link = find_all('a')[1].native.inner_text
        expect(home_link).to match(/MechaNavi/)
      end
      it 'マイページリンクが表示される: リンクが「マイページ」である' do
        home_link = find_all('a')[2].native.inner_text
        expect(home_link).to match(/マイページ/)
      end
      it 'Aboutリンクが表示される: リンクが「About」である' do
        companies_link = find_all('a')[3].native.inner_text
        expect(companies_link).to match(/About/)
      end
      it 'サービスリンクが表示される: リンクが「サービス」である' do
        companies_link = find_all('a')[4].native.inner_text
        expect(companies_link).to match(/サービス/)
      end
      it 'ログアウトリンクが表示される: リンクが「ログアウト」である' do
        logout_link = find_all('a')[9].native.inner_text
        expect(logout_link).to match(/ログアウト/)
      end
      it 'Searchリンクが表示される: 左上から6番目のリンクが「Search」である' do
        search_link = find_all('button')[1].native.inner_text
        expect(search_link).to match(/Search/)
      end
    end
  end

  describe '企業ログアウトのテスト' do
    let(:company) { create(:company) }

    before do
      visit new_company_session_path
      fill_in 'company[email]', with: company.email
      fill_in 'company[password]', with: company.password
      click_button 'ログイン'
      logout_link = find_all('a')[13].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link('About', href: '/about')
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end

  describe '社員ログアウトのテスト' do
    let(:employee) { create(:employee) }

    before do
      visit new_employee_session_path
      fill_in 'employee[email]', with: employee.email
      fill_in 'employee[password]', with: employee.password
      click_button 'ログイン'
      logout_link = find_all('a')[9].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/about'
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end

end