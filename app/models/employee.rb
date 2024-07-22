class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  belongs_to :company
  belongs_to :store
  
  has_many :posts, dependent: :destroy
  has_many :genres, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :daily_tasks, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  has_one_attached :image

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :first_name_kana, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }
  validates :last_name_kana, presence: true, format: { with: /\A[ァ-ヶー－]+\z/ }
  validates :email, presence: true, uniqueness: true

  def full_name
    "#{last_name} #{first_name}"
  end


  def company_name
    company.company_name if company.present?
  end

  scope :only_active, -> { where(is_active: true) }


  def self.guest
    find_by!(email: 'guest_employee@example.com')
  end
end
