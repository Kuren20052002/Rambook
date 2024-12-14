class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:notice] = "Post created succesfully"
      redirect_to root_path
    else
      flash.now[:alert] = "Failed to create post"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      flash[:notice] = "Post edited succesfully"
      redirect_to root_path
    else
      flash.now[:alert] = "Failed to edit post"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "Post deleted succesfully"

    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:body, :image)
  end
end
