class HeartsController < ApplicationController
  before_action :set_heartable, only: [ :create, :destroy ]

  def create
    @heart = @heartable.hearts.create(user: current_user)
    # Ensure @heartable is correctly set and saved before rendering the response
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "heart_button_#{@heartable.id}#{'_comment' if @heartable.is_a?(Comment)}",
          partial: "hearts/heart_count_and_button",
          locals: { heartable: @heartable }
        )
      end
      format.html { redirect_to @heartable, notice: "Heart added successfully" } if @heartable.class.name == "Post"
      format.html { redirect_to @heartable.post, notice: "Heart added successfully" } if @heartable.class.name == "Comment"
    end
  end

  def destroy
    @heart = @heartable.hearts.find_by(user: current_user)
    @heart.destroy if @heart
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "heart_button_#{@heartable.id}#{'_comment' if @heartable.is_a?(Comment)}",
          partial: "hearts/heart_count_and_button",
          locals: { heartable: @heartable }
        )
      end
      format.html { redirect_to @heartable, notice: "Heart removed successfully" } if @heartable.class.name == "Post"
      format.html { redirect_to @heartable.post, notice: "Heart removed successfully" } if @heartable.class.name == "Comment"
    end
  end

  private

  def set_heartable
    heartable_type = params[:heartable_type].constantize
    @heartable = heartable_type.find(params[:heartable_id])
  end
end
