class LeavesController < ApplicationController
  before_action :set_leave, only: [:show, :edit, :update, :destroy]

  # GET /leaves
  def index
    @leaves = Leave.all
  end

  # GET /leaves/1
  def show
  end

  # GET /leaves/new
  def new
    @leave = Leave.new
  end

  # GET /leaves/1/edit
  def edit
  end

  # POST /leaves
  def create
    @leave = Leave.new(leave_params)
    @leave.user = User.find(params[:leave_user_id])
    @leave.start_date = Date.parse(params[:leave_start_date])
    @leave.end_date = Date.parse(params[:leave_end_date])
    @leave.status = 'decision_pending'
    if @leave.save
      redirect_to @leave, notice: 'Leave was successfully created.'
    else
      render :new
    end
  end

  def apply
    @store = current_user.store
    @employees = @store.employees
    @leaves = @store.leaves
  end

  # PATCH/PUT /leaves/1
  def update
    if @leave.update(leave_params)
      redirect_to @leave, notice: 'Leave was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /leaves/1
  def destroy
    @leave.destroy
    redirect_to leaves_url, notice: 'Leave was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leave
      @leave = Leave.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def leave_params
      params[:leave]
    end
end
