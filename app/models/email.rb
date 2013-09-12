class Email
  include Mongoid::Document
  include Mongoid::Timestamps
  field :from, type: String
  field :to, type: String
  field :subject, type: String
  field :body, type: String

  # Validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :from, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :to,   presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :body, presence: true

  # Relations
  embedded_in :user, inverse_of: :emails

  default_scope -> { order('updated_at DESC') }
end
