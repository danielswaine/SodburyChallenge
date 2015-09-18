class CheckpointsController < ApplicationController
  before_action :set_checkpoint, only: [:show, :edit, :update, :destroy]

  # GET /checkpoints
  def index
    @checkpoints = Checkpoint.all

    respond_to do |format|
      format.html
      format.pdf do
        pdf = CheckpointPdf.new
        send_data pdf.render, filename: 'MasterList.pdf', type: "application/pdf", :disposition => 'inline'
      end
    end

  end

  # GET /checkpoints/1
  def show
  end

  # GET /checkpoints/new
  def new
    @checkpoint = Checkpoint.new
  end

  # GET /checkpoints/1/edit
  def edit
  end

  # POST /checkpoints
  def create
    @checkpoint = Checkpoint.new(checkpoint_params)

    if @checkpoint.save
      flash[:success] = "Checkpoint sucessfully created"
      redirect_to @checkpoint
    else
      render 'new'
    end

  end

  # PATCH/PUT /checkpoints/1
  def update

    if @checkpoint.update(checkpoint_params)
      flash[:success] = "Checkpoint successfully updated"
      redirect_to @checkpoint
    else
      render 'edit'
    end

  end

  # DELETE /checkpoints/1
  def destroy

    @checkpoint.destroy
    flash[:success] = "Checkpoint successfully deleted"
    redirect_to checkpoints_url

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkpoint
      @checkpoint = Checkpoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkpoint_params
      params.require(:checkpoint).permit(:CheckpointID, :GridReference, :CheckpointDescription)
    end
end
