class CalvesController < ApplicationController
  before_action :set_calf, only: [:show, :edit, :update, :destroy]

  def index
    @query  = params[:q].to_s.strip
    @status = params[:status].to_s.strip
    @view   = params[:view].to_s.strip.presence || "active"

    @calves = Calf.all

    # Group filter: active vs inactive
    case @view
    when "inactive"
      @calves = @calves.where(status: Calf.statuses.values_at("sold", "dead").compact)
    else
      @view = "active"
      @calves = @calves.where(status: Calf.statuses.values_at("healthy", "sick").compact)
    end

    # Search by name
    if @query.present?
      @calves = @calves.where("name ILIKE ?", "%#{@query}%")
    end

    # Optional specific status filter within the selected group
    if @status.present? && Calf.statuses.key?(@status)
      @calves = @calves.where(status: Calf.statuses[@status])
    end

    @calves = @calves.order(:name)
  end

  def show
    @calf_events = @calf.calf_events.order(occurred_at: :desc)
    @calf_event = @calf.calf_events.new
  end

  def new
    @calf = Calf.new
  end

  def create
    @calf = Calf.new(calf_params)
    if @calf.save
      redirect_to @calf, notice: "Calf created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @calf.update(calf_params)
      redirect_to @calf, notice: "Calf updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @calf.destroy
    redirect_to calves_path, notice: "Calf deleted successfully."
  end

  private

  def set_calf
    @calf = Calf.find(params[:id])
  end

  def calf_params
    params.require(:calf).permit(:name, :birthdate, :weight_lbs, :status)
  end
end