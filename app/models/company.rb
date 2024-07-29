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
  validates :company_name_kana, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }
  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ }
  validates :address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/ }
  validates :email, presence: true, uniqueness: true

  def active_for_authentication?
    super && is_active?
  end

  def self.guest
    find_by!(email: 'guest_company@example.com')
  end
  
  before_validation :reject_char
  
  private
  
  def reject_char
    if self.phone_number.present?
      self.phone_number = self.phone_number.to_s.gsub("-", "")
    end
  end

end
