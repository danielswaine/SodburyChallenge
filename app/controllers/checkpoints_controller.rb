require "prawn"

class CheckpointsController < ApplicationController
  before_action :set_checkpoint, only: [:show, :edit, :update, :destroy]
  #before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  # download PDF
  def download_pdf_master
    @checkpoints = Checkpoint.all
    send_data generate_pdf(@checkpoints), filename: "MasterList_#{Date.current}.pdf", type: "application/pdf", :disposition => "inline"
  end

  # GET /checkpoints
  def index
    @checkpoints = Checkpoint.all
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

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def generate_pdf(checkpoints)
        Prawn::Document.new do
          @checkpoints = checkpoints
          text "Master Checkpoint List", :align =>:center, :size => 25
          text "Exported on #{Time.now}", :align =>:center, :size => 10

          @checkpoints.map do |checkpoint|
                [checkpoint.CheckpointID]
          end
        end.render
    end

end
