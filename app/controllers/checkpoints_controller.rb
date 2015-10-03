class CheckpointsController < ApplicationController
  before_action :user_logged_in?
  before_action :find_checkpoint, only: [:edit, :update, :destroy]

  # GET /checkpoints(.:format)
  def index
    @checkpoints = Checkpoint.paginate(page: params[:page], per_page: 20).order(:number)
    respond_to do |format|
      format.html # index.html.erb
      format.pdf  # index.pdf.prawn
    end
  end

  # GET /checkpoints/new
  def new
    next_available_number = 1 + (Checkpoint.maximum(:number) || 0)
    @checkpoint = Checkpoint.new(number: next_available_number)
  end

  # POST /checkpoints
  def create
    @checkpoint = Checkpoint.new(checkpoint_params)
    if @checkpoint.save
      flash[:success] = "Checkpoint \##{@checkpoint.number} saved."
      redirect_to checkpoints_path
    else
      render 'new'
    end
  end

  # GET /checkpoints/:id/edit
  def edit
  end

  # PATCH|PUT /checkpoints/:id
  def update
    if @checkpoint.update(checkpoint_params)
      flash[:success] = "Checkpoint \##{@checkpoint.number} updated."
      redirect_to checkpoints_path
    else
      render 'edit'
    end
  end

  # DELETE /checkpoints/:id
  def destroy
    old_number = @checkpoint.number
    @checkpoint.destroy
    flash[:success] = "Checkpoint \##{old_number} deleted."
    redirect_to checkpoints_url
  end

  private

    def find_checkpoint
      @checkpoint = Checkpoint.find_by(number: params[:number])
    end

    def checkpoint_params
      params.require(:checkpoint).permit(:number, :grid_reference, :description)
    end

    def user_logged_in?
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to manage checkpoints."
        redirect_to login_url
      end
    end

end
