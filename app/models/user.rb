class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google]


  def self.find_oauth(auth)
    ## first_or_initialize→既にDBに存在するならDBから読み込む。無いなら新しく作る（newする）
    ## 既にuserがemailで登録されているか調べる（例：googleでログインしようとしたが既にメールアドレスで新規登録済み）
    user = User.where(email: auth.info.email).first_or_initialize
    ## ↓既にsns_credentialのレコードがあるかを検索する。
    sns_credential = SnsCredential.where(uid: auth.uid, provider: auth.provider).first_or_initialize
      if user.persisted? ## userが登録されているかどうか
        ## sns_credentialとuserを紐付ける。
        sns_credential.user_id = user.id
        sns_credential.save
      else ## 登録されていない
        user.nickname = auth.info.name
      end
    ## ↓がomniauthコントローラのsession["devise.sns_auth"]に入る
    return {user: user, sns: sns_credential}
  end
end
