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
  end

  def update
  end

  def show
  end

  def delete
  end

  private

  def post_params
    params.require(:post).permit(:body, :image)
  end
end
