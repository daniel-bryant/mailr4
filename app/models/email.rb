class Email
  include Mongoid::Document
  include Mongoid::Timestamps
  field :box,     type: Integer #inbox-1, sent-2, drafts-3, trash-4
  field :star,    type: Boolean
  field :from,    type: String
  field :to,      type: String
  field :subject, type: String
  field :body,    type: String
  field :date,    type: String
  field :is_new,  type: Boolean

  # Validations
  validates :box,  presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :from, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :to,   presence: true, format: { with: VALID_EMAIL_REGEX }

  embedded_in :user

  scope :by_age, order_by(updated_at: :desc)
end
