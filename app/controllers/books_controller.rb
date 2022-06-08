class BooksController < ApplicationController
  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    # to = Time.current.at_end_of_day
    # from = (to - 6.day).at_beginning_of_day
    if params[:old] # いいね順番はscopeで用意しておいて、ここでは外してある
      @books = Book.all.old
    elsif params[:evaluation_count]
      @books = Book.all.evaluation_count
    else
      @books = Book.all.latest
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def search_category
    @books = Book.search(params[:keyword])
    @word = params[:keyword]
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :category, :evaluation)
  end
end
