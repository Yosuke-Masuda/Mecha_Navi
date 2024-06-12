class Company < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :stores, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :genres, dependent: :destroy
  has_many :car_names, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :daily_tasks, dependent: :destroy

  validates :company_name, presence: true
  validates :company_name_kana, presence: true
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true



  def active_for_authentication?
    super && (is_active?)
  end

  def self.guest
    find_or_create_by!(email: 'guest_company@example.com') do |company|
      company.password = SecureRandom.urlsafe_base64
      company.company_name = "株式会社ゲスト"
      company.company_name_kana = "カブシキガイシャゲスト"
      company.postal_code = "1111111"
      company.address = "ゲスト１−１−１"
      company.phone_number = "1111111111"
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， user.name = "ゲスト" なども必要
    end
  end
end
