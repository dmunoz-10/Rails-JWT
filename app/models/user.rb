class User < ApplicationRecord
  ### Callbacks ###
  before_save  :lowercase_email

  ### Encrypt password ###
  has_secure_password

  ### Data ###
  enum gender: %i[male female transgender transsexual rather_not_to_say other]

  ### Validations ###
  # Validates presence of the following parameters
  validates_presence_of :first_name, :last_name, :username, :gender, :email,
                        :password, :password_confirmation

  # First name validation
  MESSAGE_FIRST_NAME = 'The first name must be between 3 and 50 letters'
  validates :first_name, length: { in: 3..50, message: MESSAGE_FIRST_NAME }

  # Last name validation
  MESSAGE_LAST_NAME = 'The last name must be between 3 and 50 letters'
  validates :last_name, length: { in: 3..50, message: MESSAGE_LAST_NAME }

  # Username validation
  USERNAME_REGEX = /(?![.])[a-zA-Z0-9._]+/.freeze
  MESSAGE_USERNAME = 'The username must be between 3 and 20 characters'
  validates :username, uniqueness: { case_sensitive: false }, on: :create,
                       format: { with: USERNAME_REGEX },
                       length: { in: 3..20, message: MESSAGE_USERNAME }

  # Email validation
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/.freeze
  validates :email, uniqueness: { case_sensitive: false }, on: :create,
                    format: { with: EMAIL_REGEX }, length: { maximum: 50 }

  # Password validation
  PASSWORD_MESSAGE = 'The password must be between 6 and 20 characters'
  validates :password, :password_confirmation,
            length: { in: 6..20, message: PASSWORD_MESSAGE }

  # Phone number validation
  validates :phone_number, numericality: true, uniqueness: true

  # Rewrite the json when a user is showed
  def as_json(*)
    super(except: %i[password_digest created_at updated_at])
  end

  private

  def lowercase_email
    self.email = email.downcase
  end
end
