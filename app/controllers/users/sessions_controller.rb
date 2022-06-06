class Users::SessionsController < Devise::SessionsController
  before_action :reject_user, only: [:create]
  
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: "guestuserでログインしました。"
  end

  protected

  def reject_user
    @user = User.find_by(name: params[:user][:name])
    if @user 
      if @user.valid_password?(params[:user][:password]) && (@user.is_deleted == false)
        flash[:notice] = "退会済みです。再度ご登録をしてご利用ください。"
        redirect_to new_user_registration
      else
        flash[:notice] = "項目を入力してください"
      end
    end
  end
end