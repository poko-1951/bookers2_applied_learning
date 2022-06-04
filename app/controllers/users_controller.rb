class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books.reverse_order
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week

  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def follows
    user = User.find(params[:id])
    @users = user.following
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

  def search
    @user = User.find(params[:user_id])
    @search_book = @user.books 
    @book = Book.new
    if params[:created_at] == ""
      @search_books = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_books = @search_book.where(['created_at LIKE ? ', "#{create_at}%"]).count
    end
    render :post_search
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
