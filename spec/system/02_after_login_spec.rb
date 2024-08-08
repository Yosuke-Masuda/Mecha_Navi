require 'rails_helper'

describe '[STEP2] 企業ログイン後のテスト' do
  let(:company) { create(:company) }
  let!(:other_company) { create(:company) }
  let!(:store) { create(:store, company: company) }
  let!(:other_store) { create(:store, company: other_company) }
  let!(:car_name) { create(:car_name, company: company) }
  let!(:other_car_name) { create(:car_name, company: other_company) }
  let!(:genre) { create(:genre, company: company) }
  let!(:other_genre) { create(:genre, company: other_company) }
  let!(:task) { create(:task, company: company) }
  let!(:other_task) { create(:task, company: other_company) }
  let!(:employee) { create(:employee, company: company) }
  let!(:post) { create(:post, company: company, employee: employee, car_name: car_name) }

  before do
    # sign_in company
    visit new_company_session_path
    fill_in 'company[email]', with: company.email
    fill_in 'company[password]', with: company.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'マイページを押すと、企業詳細画面に遷移する' do
        home_link = find_all('a')[2].native.inner_text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/companies/mypage'
      end
      it '社員のドロップダウンで社員登録を押すと、社員登録画面に遷移する' do
        companies_link = find_all('a')[4].native.inner_text
        companies_link = companies_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link companies_link
        is_expected.to eq '/companies/' + company.id.to_s + '/employees/new'
      end
      it '社員のドロップダウンで社員一覧 / タスク進捗を押すと、社員一覧画面に遷移する' do
        companies_link = find_all('a')[5].native.inner_text
        companies_link = companies_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link companies_link
        is_expected.to eq '/companies/' + company.id.to_s + '/employees'
      end
      it 'サービスのドロップダウンで投稿履歴管理を押すと、投稿履歴管理画面に遷移する' do
        companies_link = find_all('a')[7].native.inner_text
        companies_link = companies_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link companies_link
        is_expected.to eq '/top'
      end
      it 'サービスのドロップダウンで投稿管理を押すと、投稿管理画面に遷移する' do
        posts_link = find_all('a')[8].native.inner_text
        posts_link = posts_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link posts_link
        is_expected.to eq '/companies/' + company.id.to_s + '/employees/posts'
      end
      it 'サービスのドロップダウンで店舗管理を押すと、店舗管理画面へ遷移する' do
        stores_link = find_all('a')[9].native.inner_text
        stores_link = stores_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link stores_link
        is_expected.to eq '/companies/' + company.id.to_s + '/stores'
      end
      it 'サービスのドロップダウンで車両管理を押すと、車両管理画面へ遷移する' do
        car_names_link = find_all('a')[10].native.inner_text
        car_names_link = car_names_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link car_names_link
        is_expected.to eq '/companies/' + company.id.to_s + '/car_names'
      end
      it 'サービスのドロップダウンでジャンル管理を押すと、ジャンル管理画面へ遷移する' do
        genres_link = find_all('a')[11].native.inner_text
        genres_link = genres_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link genres_link
        is_expected.to eq '/companies/' + company.id.to_s + '/genres'
      end
      it 'サービスのドロップダウンでタスク管理を押すと、タスク管理画面へ遷移する' do
        tasks_link = find_all('a')[12].native.inner_text
        tasks_link = tasks_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link tasks_link
        is_expected.to eq '/companies/' + company.id.to_s + '/tasks'
      end
    end
  end

  describe '新規社員登録のテスト' do
    before do
      visit new_company_employee_path(company)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/employees/new'
      end
      it '「新規社員登録」と表示される' do
        expect(page).to have_content '新規社員登録'
      end
      it '勤務地選択フォームが表示される' do
        expect(page).to have_field 'employee[store_id]'
      end
      it 'プロフィール画像の選択が表示される' do

      end
      it 'last_nameフォームが表示される' do
        expect(page).to have_field 'employee[last_name]'
      end
      it 'first_nameフォームが表示される' do
        expect(page).to have_field 'employee[first_name]'
      end
      it 'last_name_kanaフォームが表示される' do
        expect(page).to have_field 'employee[last_name_kana]'
      end
      it 'first_name_kanaフォームが表示される' do
        expect(page).to have_field 'employee[first_name_kana]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'employee[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'employee[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'employee[password_confirmation]'
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        select store.name, from: "employee[store_id]"
        attach_file 'employee[image]', Rails.root.join("spec/support/images/no_image.jpg")
        fill_in 'employee[last_name]', with: employee.last_name
        fill_in 'employee[first_name]', with: employee.first_name
        fill_in 'employee[last_name_kana]', with: employee.last_name_kana
        fill_in 'employee[first_name_kana]', with: employee.first_name_kana
        fill_in 'employee[email]', with: Faker::Internet.email
        fill_in 'employee[password]', with: 'password'
        fill_in 'employee[password_confirmation]', with: 'password'
        find(:xpath, all('button')[2].path).click
      end

      it '正しく新規登録される' do
        expect(Employee.count).to be >= 1
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの一覧画面になっている' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/employees'
      end
    end
  end


  describe '社員一覧 / タスク進捗画面のテスト' do
    before do
      visit company_employees_path(company)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/employees'
      end
      it "社員名のリンク先が正しい" do
        expect(page).to have_link '', href: '/companies/' + company.id.to_s + '/employees/' + employee.id.to_s
      end
      it "タスク進捗ボタンのリンク先が正しい" do
        expect(page).to have_link '', href: company_employee_calendar_path(company, employee)
      end
    end

    context '社員一覧画面のテスト' do
      it '社員名をクリックすると社員詳細画面へ遷移する' do
        click_link employee.full_name
        expect(current_path).to eq '/companies/' + company.id.to_s + '/employees/' + employee.id.to_s
      end
      it 'タスク進捗ボタンをクリックするとタスクカレンダー画面へ遷移する' do
        click_link 'タスク進捗'
        expect(current_path).to eq company_employee_calendar_path(company, employee)
      end
    end
  end

  describe '社員詳細画面のテスト' do
    before do
      visit company_employee_path(company, employee)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/employees/' + employee.id.to_s
      end
      it 'プロフィール画像が表示される' do
        expect(page).to have_css('img') # imgタグが表示されることを確認
      end
      it '勤務地が表示される' do
        expect(page).to have_content(employee.store.name) # 勤務地の店名が表示されることを確認
      end
      it '氏名が表示される' do
        expect(page).to have_content(employee.last_name) # 姓が表示されることを確認
        expect(page).to have_content(employee.first_name) # 名が表示されることを確認
      end

      it 'フリガナが表示される' do
        expect(page).to have_content(employee.last_name_kana) # セイが表示されることを確認
        expect(page).to have_content(employee.first_name_kana) # メイが表示されることを確認
      end

      it 'メールアドレスが表示される' do
        expect(page).to have_content(employee.email) # メールアドレスが表示されることを確認
      end

      it 'ステータスが表示される' do
        if employee.is_active?
          expect(page).to have_css('p.text-success', text: '有効') # 有効ステータスが表示されることを確認
        else
          expect(page).to have_css('p.text-secondary', text: '退職') # 退職ステータスが表示されることを確認
        end
      end

      it '編集、社員一覧ボタンが存在する' do
        expect(page).to have_link "編集", href: edit_company_employee_path(company, employee)
        expect(page).to have_link "社員一覧", href: company_employees_path(company)
      end
    end
  end

  describe '社員編集画面のテスト' do
    before do
      visit edit_company_employee_path(company, employee)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/employees/' + employee.id.to_s + '/edit'
      end
      it '店舗セレクトボックスが表示される' do
        store_options = company.stores.select{ |store| store.is_active }.map { |store| [store.name, store.id] }

        select_options = page.find('#employee_store_id').all('option')

        expect(select_options.size).to eq(store_options.size)
        select_options.drop(1).each_with_index do |option, index|
          expect(option.text).to eq(store_options[index][0])
          expect(option.value).to eq(store_options[index][1].to_s)
        end
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
      it 'ステータスが表示されること' do
        if employee.is_active?
          expect(page).to have_css('div.form-group', text: '有効') # 有効ステータスが表示されることを確認
        else
          expect(page).to have_css('div.form-group', text: '退職') # 退職ステータスが表示されることを確認
        end
      end
      it '保存、戻るボタンが存在すること' do
        expect(page).to have_button('保存')
        expect(page).to have_link('', href: company_employee_path(company.id, employee.id))
      end
      it '戻るボタンを押すと詳細画面へ遷移する' do
        click_link '戻る'
        expect(current_path).to eq company_employee_path(company.id, employee.id)
      end
    end

    context '社員編集のテスト' do
      before do
        employee = FactoryBot.create(:employee)
        @employee_old_store = employee.store
        @employee_old_last_name = employee.last_name
        @employee_old_first_name = employee.first_name
        @employee_old_last_name_kana = employee.last_name_kana
        @employee_old_first_name_kana = employee.first_name_kana
        @employee_old_email = employee.email
        select store.name, from: "employee[store_id]"
        attach_file 'employee[image]', Rails.root.join("spec/support/images/no_image.jpg")
        fill_in 'employee[last_name]', with: Gimei.name.last.kanji
        fill_in 'employee[first_name]', with: Gimei.name.first.kanji
        fill_in 'employee[last_name_kana]', with: Gimei.name.last.katakana
        fill_in 'employee[first_name_kana]', with: Gimei.name.first.katakana
        fill_in 'employee[email]', with: Faker::Internet.email
        choose 'employee[is_active]', with: true
        find(:xpath, all('button')[2].path).click
      end
      it 'storeが正しく更新される' do
        expect(employee.reload.store).not_to eq @employee_old_store
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
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq company_employee_path(company.id, employee.id)
      end
    end
  end

  describe '投稿履歴一覧画面のテスト' do
    before do
      visit top_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/top'
      end
      it '社員名のリンク先が正しい' do
        expect(page).to have_link '', href: '/companies/' + company.id.to_s + '/employees/' + employee.id.to_s + '/posts/' + post.id.to_s
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit company_employee_posts_path(company)
    end

    context '表示内容の確認' do
      it "URLが正しい" do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/employees/posts'
      end
      it '各リンク先が正しい' do
        expect(page).to have_link '詳細', href: company_employee_post_path(company.id, post.employee_id, post.id)
        expect(page).to have_link '編集', href: edit_company_employee_post_path(company.id, post.employee_id, post.id)
        expect(page).to have_link '削除', href: company_employee_post_path(company.id, post.employee_id, post.id)
      end
      it '詳細を押すと、投稿詳細画面に遷移する' do
        click_link '詳細'
        expect(current_path).to eq '/companies/' + company.id.to_s + '/employees/' + post.employee_id.to_s + '/posts/' + post.id.to_s
      end
      it '編集を押すと投稿編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq '/companies/' + company.id.to_s + '/employees/' + post.employee_id.to_s + '/posts/' + post.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end

      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/employees/posts'
      end
    end

  end

  describe '店舗一覧画面のテスト' do
    before do
      visit company_stores_path(company)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/stores'
      end
      it '「店舗管理」と表示される' do
        expect(page).to have_content '店舗管理'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'store[name]'
      end
      it 'is_activeフォームが表示される' do
        expect(page).to have_field 'store[is_active]'
      end

      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '店舗名のリンク先が正しい' do
        expect(page).to have_link store.name, href: company_store_path(company, store)
      end
      it '編集ボタンのリンク先が正しい' do
        expect(page).to have_link '', href: edit_company_store_path(company, store)
      end
    end

    context '店舗登録のテスト' do
      before do
        fill_in 'store[name]', with: Faker::Name.name
        choose 'store[is_active]', with: true
        click_button '登録'
      end

      it '正しく新規登録される' do
        expect(Store.count).to be >= 1
      end
      it '新規登録後の店舗管理（一覧画面）にリダイレクトされる' do
        click_button '登録'
        expect(current_path).to eq '/companies/' + company.id.to_s + '/stores'
      end
    end

  end

  describe '店舗編集画面のテスト' do
    before do
      visit edit_company_store_path(company, store)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/stores/' + store.id.to_s + '/edit'
      end
      it '「店舗編集」と表示される' do
        expect(page).to have_content '店舗編集'
      end
      it '店舗名が正しく表示されること' do
        expect(page).to have_field('store_name')
      end
      it 'ステータスが表示されること' do
        if store.is_active?
          expect(page).to have_css('div.form-group', text: '有効') # 有効ステータスが表示されることを確認
        else
          expect(page).to have_css('div.form-group', text: '退職') # 退職ステータスが表示されることを確認
        end
      end
      it '保存、戻るボタンが存在すること' do
        expect(page).to have_button('保存')
        expect(page).to have_link('', href: company_stores_path(company.id))
      end
      it '戻るボタンを押すと詳細画面へ遷移する' do
        click_link '戻る'
        expect(current_path).to eq company_stores_path(company.id)
      end
    end

    context '店舗編集のテスト' do
      before do
        store = FactoryBot.create(:store)
        @store_old_name = store.name
        fill_in 'store[name]', with: Faker::Name.name
        choose 'store[is_active]', with: true
        find(:xpath, all('button')[2].path).click
      end
      it '店舗名が正しく更新される' do
        expect(store.reload.name).not_to eq @store_old_name
      end
      it 'リダイレクト先が、更新した店舗の一覧画面になっている' do
        expect(current_path).to eq company_stores_path(company.id)
      end
    end
  end

  describe '車両管理画面のテスト' do
    before do
      visit company_car_names_path(company)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/car_names'
      end
      it '「車両管理」と表示される' do
        expect(page).to have_content '車両管理'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'car_name[name]'
      end
      it 'car_typeフォームが表示される' do
        expect(page).to have_field 'car_name[car_type]'
      end
      it 'is_activeフォームが表示される' do
        expect(page).to have_field 'car_name[is_active]'
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '編集ボタンのリンク先が正しい' do
        expect(page).to have_link '', href: edit_company_car_name_path(company, car_name)
      end
    end

    context '一覧画面のテスト' do
      before do
        fill_in 'car_name[name]', with: Faker::Name.name
        fill_in 'car_name[car_type]', with: Faker::Lorem.characters(number: 10)
        choose 'car_name[is_active]', with: true
        click_button '登録'
      end

      it '正しく新規登録される' do
        expect(CarName.count).to be >= 1
      end
      it '新規登録後の車両管理（一覧画面）にリダイレクトされる' do
        click_button '登録'
        expect(current_path).to eq '/companies/' + company.id.to_s + '/car_names'
      end
    end
  end

  describe '店舗編集画面のテスト' do
    before do
      visit edit_company_car_name_path(company, car_name)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/car_names/' + car_name.id.to_s + '/edit'
      end
      it '「車名編集」と表示される' do
        expect(page).to have_content '車名編集'
      end
      it '車名が正しく表示されること' do
        expect(page).to have_field('car_name_name')
      end
      it '車名が正しく表示されること' do
        expect(page).to have_field('car_name_car_type')
      end
      it 'ステータスが表示されること' do
        if car_name.is_active?
          expect(page).to have_css('div.form-group', text: '有効') # 有効ステータスが表示されることを確認
        else
          expect(page).to have_css('div.form-group', text: '退職') # 退職ステータスが表示されることを確認
        end
      end
      it '保存、戻るボタンが存在すること' do
        expect(page).to have_button('保存')
        expect(page).to have_link('', href: company_car_names_path(company.id))
      end
      it '戻るボタンを押すと詳細画面へ遷移する' do
        click_link '戻る'
        expect(current_path).to eq company_car_names_path(company.id)
      end
    end

    context '車名編集のテスト' do
      before do
        car_name = FactoryBot.create(:car_name)
        @car_name_old_name = car_name.name
        @car_name_old_car_type = car_name.car_type
        fill_in 'car_name[name]', with: Faker::Name.name
        fill_in 'car_name[car_type]', with: Faker::Lorem.characters(number: 10)
        choose 'car_name[is_active]', with: true
        find(:xpath, all('button')[2].path).click
      end
      it '車名が正しく更新される' do
        expect(car_name.reload.name).not_to eq @car_name_old_name
      end
      it '型式が正しく更新される' do
        expect(car_name.reload.car_type).not_to eq @car_name_old_car_type
      end
      it 'リダイレクト先が、更新した店舗の一覧画面になっている' do
        expect(current_path).to eq company_car_names_path(company.id)
      end
    end
  end

  describe 'ジャンル管理画面のテスト' do
    before do
      visit company_genres_path(company)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/genres'
      end
      it '「車両管理」と表示される' do
        expect(page).to have_content 'ジャンル管理'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'genre[name]'
      end
      it 'is_activeフォームが表示される' do
        expect(page).to have_field 'genre[is_active]'
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '編集ボタンのリンク先が正しい' do
        expect(page).to have_link '', href: edit_company_genre_path(company, genre)
      end
    end

    context '一覧画面のテスト' do
      before do
        fill_in 'genre[name]', with: Faker::Name.name
        choose 'genre[is_active]', with: true
      end

      it '正しく新規登録される' do
        expect { click_button '登録' }.to change{Genre.count}.by(1)
      end
      it '新規登録後の車両管理（一覧画面）にリダイレクトされる' do
        click_button '登録'
        expect(current_path).to eq '/companies/' + company.id.to_s + '/genres'
      end
    end
  end

  describe 'ジャンル編集画面のテスト' do
    before do
      visit edit_company_genre_path(company, genre)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/genres/' + genre.id.to_s + '/edit'
      end
      it '「ジャンル編集」と表示される' do
        expect(page).to have_content 'ジャンル編集'
      end
      it 'ジャンル名が正しく表示されること' do
        expect(page).to have_field('genre_name')
      end
      it 'ステータスが表示されること' do
        if genre.is_active?
          expect(page).to have_css('div.form-group', text: '有効') # 有効ステータスが表示されることを確認
        else
          expect(page).to have_css('div.form-group', text: '退職') # 退職ステータスが表示されることを確認
        end
      end
      it '保存、戻るボタンが存在すること' do
        expect(page).to have_button('保存')
        expect(page).to have_link('', href: company_genres_path(company.id))
      end
      it '戻るボタンを押すと詳細画面へ遷移する' do
        click_link '戻る'
        expect(current_path).to eq company_genres_path(company.id)
      end
    end

    context 'ジャンル編集のテスト' do
      before do
        genre = FactoryBot.create(:store)
        @genre_old_name = genre.name
        fill_in 'genre[name]', with: Faker::Name.name
        choose 'genre[is_active]', with: true
        find(:xpath, all('button')[2].path).click
      end
      it 'ジャンル名が正しく更新される' do
        expect(genre.reload.name).not_to eq @genre_old_name
      end
      it 'リダイレクト先が、更新した店舗の一覧画面になっている' do
        expect(current_path).to eq company_genres_path(company.id)
      end
    end
  end

  describe 'タスク管理画面のテスト' do
    before do
      visit company_tasks_path(company)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/tasks'
      end
      it '「タスク管理」と表示される' do
        expect(page).to have_content 'タスク管理'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'task[name]'
      end
      it 'bodyフォームが表示される' do
        expect(page).to have_field 'task[body]'
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '編集ボタンのリンク先が正しい' do
        expect(page).to have_link '', href: edit_company_task_path(company, task)
      end
    end

    context '一覧画面のテスト' do
      before do
        fill_in 'task[name]', with: Faker::Name.name
        fill_in 'task[body]', with: Faker::Lorem.characters(number: 20)
      end

      it '正しく新規登録される' do
        expect { click_button '登録' }.to change{Task.count}.by(1)
      end
      it '新規登録後の車両管理（一覧画面）にリダイレクトされる' do
        click_button '登録'
        expect(current_path).to eq '/companies/' + company.id.to_s + '/tasks'
      end
    end
  end

  describe 'タスク編集画面のテスト' do
    before do
      visit edit_company_task_path(company, task)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/companies/' + company.id.to_s + '/tasks/' + task.id.to_s + '/edit'
      end
      it '「タスク編集」と表示される' do
        expect(page).to have_content 'タスク編集'
      end
      it 'タスク名が正しく表示されること' do
        expect(page).to have_field('task_name')
      end
      it 'タスク内容が正しく表示されること' do
        expect(page).to have_field('task_body')
      end
      it '保存、削除、戻るボタンが存在すること' do
        expect(page).to have_button('保存')
        expect(page).to have_link "", href: company_task_path(company.id, task.id)
        expect(page).to have_link "", href: company_tasks_path(company.id)
      end
      it '戻るボタンを押すとタスク一覧画面へ遷移する' do
        click_link '戻る'
        expect(current_path).to eq company_tasks_path(company.id)
      end
    end

    context 'タスク編集のテスト' do
      before do
        task = FactoryBot.create(:task)
        @task_old_name = task.name
        @task_old_body = task.body
        fill_in 'task[name]', with: Faker::Name.name
        fill_in 'task[body]', with: Faker::Lorem.characters(number: 20)
        find(:xpath, all('button')[2].path).click
      end
      it 'タスク名が正しく更新される' do
        expect(task.reload.name).not_to eq @task_old_name
      end
      it 'タスク内容が正しく更新される' do
        expect(task.reload.body).not_to eq @task_old_body
      end
      it 'リダイレクト先が、更新した店舗の一覧画面になっている' do
        expect(current_path).to eq company_tasks_path(company.id)
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end

      it '正しく削除される' do
        expect(Task.where(id: task.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq company_tasks_path(company.id)
      end
    end
  end


end