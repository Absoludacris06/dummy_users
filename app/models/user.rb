

class User < ActiveRecord::Base
  attr_accessor :new_password, :new_password_confirmation

  validates_confirmation_of :new_password, :if => :password_changed?
  validates :email, uniqueness: true, presence: true
  validates :name, presence: true
  validates :new_password, presence: true, length: { minimum: 5, maximum: 12 }, :if => :password_changed?

  before_save :hash_new_password, :if => :password_changed?

  def password_changed?
    !@new_password.blank?
  end

  def self.authenticate(email, password)
    if user = find_by_email(email)
      if BCrypt::Password.new(user.hashed_password).is_password? password
        return user
      end
    end
    return nil
  end

  private
  def hash_new_password
    self.hashed_password = BCrypt::Password.create(@new_password)
  end

end
