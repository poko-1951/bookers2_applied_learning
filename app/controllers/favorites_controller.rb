class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
    to = Time.current.at_end_of_day
    from = (to-6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).sort{
      |a,b| 
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
    }
    render "create_and_destroy"
    # redirect_to request.referer
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    to = Time.current.at_end_of_day
    from = (to-6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).sort{
      |a,b| 
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
    }
    render "create_and_destroy"
    # redirect_to request.referer
  end
  
end
