class TurnsController < ApplicationController
  before_action :set_turn, only: [:show, :edit, :update, :destroy]

  def index
    TurnManagerJob.perform_later

    if session[:turn]
      @turn = Turn.find(session.dig(:turn, "id"))
    else
      @turn = Turn.create
      session[:turn] = { id: @turn.id, value: @turn.value }
    end
  end

  def show
  end

  def new
    @turn = Turn.new
  end

  def create
    @turn = Turn.new(turn_params)

    if @turn.save
      redirect_to turns_path, notice: "Turn was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @turn.update(turn_params)
      redirect_to turns_path, notice: "Turn was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @turn.destroy
    redirect_to turns_path, notice: "Turn was successfully destroyed."
  end

  private

  def set_turn
    @turn = Turn.find(params[:id])
  end

  def turn_params
    params.require(:turn).permit(:value, :status)
  end
end
