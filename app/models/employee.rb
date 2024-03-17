class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :company
  belongs_to :store, optional: true
  has_many :posts, dependent: :nullify
  has_many :genres, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :image
  
  
  def company_name
    company.name if company.present?
  end
  
  scope :only_active, -> { where(is_active: true) }
  
  validates_presence_of :first_name, :last_name, :first_name_kana, :last_name_kana
  validates_format_of :first_name_kana, :last_name_kana, with: /\A[ァ-ヶー－]+\z/
  
  def self.looks(search, word)
   if search == "perfect_match"
     @employee = Employee.where("first_name LIKE? OR last_name LIKE?", "#{word}", "#{word}")
   elsif search == "forward_match"
     @employee = Employee.where("first_name LIKE? OR last_name LIKE?", "#{word}%", "#{word}%")
   elsif search == "backward_match"
     @employee = Employee.where("first_name LIKE? OR last_name LIKE?", "%#{word}", "%#{word}")
   elsif search == "partial_match"
     @employee = Employee.where("first_name LIKE? OR last_name LIKE?", "%#{word}%", "%#{word}%")
   else
     @employee = Employee.all
   end
  end
         
end
