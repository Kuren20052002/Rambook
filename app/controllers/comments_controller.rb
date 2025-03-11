class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy]
  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Comment created succesfully"
      redirect_to post_path(@post)
    else
      flash.now[:alert] = "Unable to create comment"
      render "posts/show", status: :unprocessable_entity
    end
  end

  def edit
    @comment = @post.comments.find(params[:id])
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = "Comment edited succesfully"
      redirect_to @post
    else
      flash.now[:alert] = "Failed to edit comment"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = "Comment deleted succesfully"
    redirect_to @post
  end

  private

  def set_comment
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :image)
  end
end
