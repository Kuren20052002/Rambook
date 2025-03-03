class FollowsController < ApplicationController
  before_action :authenticate_user!, :set_user
  def create
    respond_to do |format|
      if current_user.follow(@user)
        format.turbo_stream { render turbo_stream: turbo_stream.update(:follow_button, partial: "follows/follow_button", locals: { user: @user }) }
        format.html { redirect_to @user, notice: "Followed user" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to @user, alert: "Failed to follow user" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if current_user.unfollow(@user)
        format.turbo_stream { render turbo_stream: turbo_stream.update(:follow_button, partial: "follows/follow_button", locals: { user: @user }) }
        format.html { redirect_to @user, notice: "Unfollowed user" }
        format.json { head :no_content }
      else
        format.html { redirect_to @user, alert: "Failed to unfollow user" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def follow_params
    params.require(:follow).permit(:id)
  end
end
