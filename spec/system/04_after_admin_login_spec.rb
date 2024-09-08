require "rails_helper"

describe "[STEP4] 管理者ログイン後のテスト" do
  let(:admin) { create(:admin) }
  let!(:company) { create(:company) }
  let!(:other_company) { create(:company) }
  let!(:car_name) { create(:car_name, company: company) }
  let!(:other_car_name) { create(:car_name, company: other_company) }
  let!(:store) { create(:store, company: company) }
  let!(:othere_store) { create(:store, company: company) }
  let!(:genre) { create(:genre, company: company) }
  let!(:other_genre) { create(:genre, company: company) }
  let!(:employee) { create(:employee, company: company) }
  let!(:post) { create(:post, company: company, employee: employee, car_name: car_name, store: store, genre: genre) }

  before do
    visit new_admin_session_path
    fill_in "admin[email]", with: admin.email
    fill_in "admin[password]", with: admin.password
    click_button "ログイン"
  end

  describe "ヘッダーのテスト: ログインしている場合" do
    context "リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。" do
      subject { current_path }

      it "投稿管理を押すと、投稿履歴一覧画面に遷移する" do
        home_link = find_all("a")[2].native.inner_text
        home_link = home_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link home_link
        is_expected.to eq "/admin/top"
      end
      it "顧客一覧を押すと、顧客一覧画面に遷移する" do
        home_link = find_all("a")[3].native.inner_text
        home_link = home_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link home_link
        is_expected.to eq "/admin/companies"
      end
      it "サービスのドロップダウンで店舗管理を押すと、店舗一覧画面へ遷移する" do
        employee_link = find_all("a")[5].native.inner_text
        employee_link = employee_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link employee_link
        is_expected.to eq "/admin/stores"
      end
      it "サービスのドロップダウンでジャンル管理を押すと、ジャンル一覧画面へ遷移する" do
        post_link = find_all("a")[6].native.inner_text
        post_link = post_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link post_link
        is_expected.to eq "/admin/genres"
      end
      it "サービスのドロップダウンで車両管理を押すと、車両一覧画面へ遷移する" do
        post_link = find_all("a")[7].native.inner_text
        post_link = post_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link post_link
        is_expected.to eq "/admin/car_names"
      end
      it "サービスのドロップダウンでタスク管理を押すと、タスクカレンダー画面へ遷移する" do
        post_link = find_all("a")[8].native.inner_text
        post_link = post_link.delete("\n").gsub(/\A\s*/, "").gsub(/\s*\Z/, "")
        click_link post_link
        is_expected.to eq "/admin/tasks"
      end
    end
  end

  describe "店舗一覧画面のテスト" do
    before do
      visit admin_stores_path
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/admin/stores"
      end
      it "「店舗管理」と表示される" do
        expect(page).to have_content "店舗管理"
      end
      it "nameフォームが表示される" do
        expect(page).to have_field "store[name]"
      end
      it "is_activeフォームが表示される" do
        expect(page).to have_field "store[is_active]"
      end

      it "登録ボタンが表示される" do
        expect(page).to have_button "登録"
      end
      it "店舗名のリンク先が正しい" do
        expect(page).to have_link store.name, href: admin_store_path(store)
      end
      it "編集ボタンのリンク先が正しい" do
        expect(page).to have_link "", href: edit_admin_store_path(store)
      end
    end

    context "店舗登録のテスト" do
      before do
        fill_in "store[name]", with: Faker::Name.name
        choose "store[is_active]", with: true
        click_button "登録"
      end

      it "正しく新規登録される" do
        expect(Store.count).to be >= 1
      end
      it "新規登録後の店舗管理（一覧画面）にリダイレクトされる" do
        click_button "登録"
        expect(current_path).to eq "/admin/stores"
      end
    end
  end

  describe "店舗編集画面のテスト" do
    before do
      visit edit_admin_store_path(store)
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/admin/stores/" + store.id.to_s + "/edit"
      end
      it "「店舗編集」と表示される" do
        expect(page).to have_content "店舗編集"
      end
      it "店舗名が正しく表示されること" do
        expect(page).to have_field("store_name")
      end
      it "ステータスが表示されること" do
        if store.is_active?
          expect(page).to have_css("div.form-group", text: "有効") # 有効ステータスが表示されることを確認
        else
          expect(page).to have_css("div.form-group", text: "無効") # 退職ステータスが表示されることを確認
        end
      end
      it "保存、戻るボタンが存在すること" do
        expect(page).to have_button("保存")
        expect(page).to have_link("戻る", href: admin_stores_path)
      end
      it "戻るボタンを押すと一覧画面へ遷移する" do
        click_link "戻る"
        expect(current_path).to eq admin_stores_path
      end
    end

    context "店舗編集のテスト" do
      before do
        store = FactoryBot.create(:store)
        @store_old_name = store.name
        fill_in "store[name]", with: Faker::Name.name
        choose "store[is_active]", with: true
        find(:xpath, all("button")[2].path).click
      end
      it "店舗名が正しく更新される" do
        expect(store.reload.name).not_to eq @store_old_name
      end
      it "リダイレクト先が、更新した店舗の一覧画面になっている" do
        expect(current_path).to eq admin_stores_path
      end
    end
  end

  describe "ジャンル管理画面のテスト" do
    before do
      visit admin_genres_path
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/admin/genres"
      end
      it "「車両管理」と表示される" do
        expect(page).to have_content "ジャンル管理"
      end
      it "nameフォームが表示される" do
        expect(page).to have_field "genre[name]"
      end
      it "is_activeフォームが表示される" do
        expect(page).to have_field "genre[is_active]"
      end
      it "登録ボタンが表示される" do
        expect(page).to have_button "登録"
      end
      it "編集ボタンのリンク先が正しい" do
        expect(page).to have_link "", href: edit_admin_genre_path(genre)
      end
    end

    context "一覧画面のテスト" do
      before do
        fill_in "genre[name]", with: Faker::Name.name
        choose "genre[is_active]", with: true
        click_button "登録"
      end

      it "正しく新規登録される" do
        expect(Genre.count).to be >= 1
      end
      it "新規登録後の車両管理（一覧画面）にリダイレクトされる" do
        click_button "登録"
        expect(current_path).to eq "/admin/genres"
      end
    end
  end
end