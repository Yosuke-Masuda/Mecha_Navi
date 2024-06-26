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
  validates :company_name, presence: true
  validates :company_name_kana, presence: true
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true



  def active_for_authentication?
    super && (is_active?)
  end

  def self.guest
    find_by!(email: 'guest_company@example.com')
  end
end
