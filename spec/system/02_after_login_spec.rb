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
        expect(current_path).to eq '/companies/2/employees/new'
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

    end
  end

  describe '投稿履歴一覧画面のテスト' do
    # let!(:post) { create(:post, company: company, employee: employee, car_name: car_name, car_type_id: car_name) }
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
    # let!(:post) { create(:post, employee: employee) }
    before do
      visit company_employee_posts_path(company)
    end

    context '表示内容の確認' do
      it "URLが正しい" do
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
      # it 'is_activeフォームが表示される' do
      #   expect(page).to have_field 'store[is_active]'
      # end

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

    context '店舗のテスト' do
      before do
        # sign_in company
        fill_in 'store[name]', with: Faker::Name.name
        # fill_in 'store[is_active]', with: true
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
      # it 'is_activeフォームが表示される' do
      #   expect(page).to have_field 'car_name[is_active]'
      # end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '編集ボタンのリンク先が正しい' do
        expect(page).to have_link '', href: edit_company_car_name_path(company, car_name)
      end
    end

    context '一覧画面のテスト' do
      before do
        # sign_in company
        fill_in 'car_name[name]', with: Faker::Name.name
        fill_in 'car_name[car_type]', with: Faker::Lorem.characters(number: 10)
        # fill_in 'car_name[is_active]', with: true
      end

      it '正しく新規登録される' do
        expect { click_button '登録' }.to change{CarName.count}.by(1)
      end
      it '新規登録後の車両管理（一覧画面）にリダイレクトされる' do
        click_button '登録'
        expect(current_path).to eq '/companies/' + company.id.to_s + '/car_names'
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
      # it 'is_activeフォームが表示される' do
      #   expect(page).to have_field 'genre[is_active]'
      # end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '編集ボタンのリンク先が正しい' do
        expect(page).to have_link '', href: edit_company_genre_path(company, genre)
      end
    end

    context '一覧画面のテスト' do
      before do
        # sign_in company
        fill_in 'genre[name]', with: Faker::Name.name
        # fill_in 'genre[is_active]', with: true
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
      # it 'is_activeフォームが表示される' do
      #   expect(page).to have_field 'task[is_active]'
      # end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it '編集ボタンのリンク先が正しい' do
        expect(page).to have_link '', href: edit_company_task_path(company, task)
      end
    end

    context '一覧画面のテスト' do
      before do
        # sign_in company
        fill_in 'task[name]', with: Faker::Name.name
        fill_in 'task[body]', with: Faker::Lorem.characters(number: 20)
        # fill_in 'task[is_active]', with: true
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


end