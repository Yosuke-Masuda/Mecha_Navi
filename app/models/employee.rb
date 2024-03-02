class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :company
  belongs_to :store, optional: true
  has_many :posts, dependent: :destroy
  has_many :genres, dependent: :destroy
  
  def company_name
    company.name if company.present?
  end
  
  scope :only_active, -> { where(is_active: true) }
  
  validates_presence_of :first_name, :last_name, :first_name_kana, :last_name_kana
  validates_format_of :first_name_kana, :last_name_kana, with: /\A[ァ-ヶー－]+\z/
         
end
