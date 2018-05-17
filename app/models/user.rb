class User < ApplicationRecord
  has_many :microposts,dependent: :destroy
  has_many :likes
  has_many :like_microposts, through: :likes, source: 'micropost'
  mount_uploader :profileimage, ProfileimageUploader
  attr_accessor :remember_token,:reset_token
  before_save {self.email = email.downcase}
  validates :name,presence: true,length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,presence: true,length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX },uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}, if: :normal_login?
  has_secure_password

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
  SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest,User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest,nil)
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,User.digest(reset_token))
    update_attribute(:reset_sent_at,Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # メールアドレスを小文字にする
  def downcase_email
    self.email = email.downcase
  end

  # パスワード再設定が期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  #引数に関連するユーザーが存在すればそれを返し、存在しまければ新規に作成する
  def self.find_or_create_from_auth_hash(auth_hash)
    user = User.find_by(email: auth_hash[:info][:email])
    if user.nil?
      user = User.create(
        email: auth_hash[:info][:email],
        provider: auth_hash[:provider],
        uid: auth_hash[:uid],
        name: auth_hash[:info][:nickname],
        image_url: auth_hash[:info][:image]
      )
    end

    user
  end

  def normal_login?
    uid.blank?
  end
end
