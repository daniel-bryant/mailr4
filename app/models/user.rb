class User
  include Mongoid::Document
  # Fields
  field :name, type: String
  field :first, type:String
  field :last, type:String
  field :password_digest, type:String
  
  index({ name: 1 }, { unique: true })

  # Validations
  before_save { self.name = name.downcase }
  validates :name,     presence: true, length: { maximum: 50, minimum: 3 },
                       uniqueness: { case_sensitive: false }
  validates :first,    presence: true, length: { maximum: 50 }
  validates :last,     presence: true, length: { maximum: 50 }
  has_secure_password
  validates :password, length: { minimum: 8 }
end
