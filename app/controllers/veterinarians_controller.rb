class VeterinariansController < ApplicationController
  def index
    @veterinarians = Veterinarian.on_call
  end

  def show
    @veterinarian = Veterinarian.find(params[:id])
  end

  def new
    @vet_office = VeterinaryOffice.find(params[:id])
    @veterinarian = Veterinarian.new
  end

  def create
    @vet_office = VeterinaryOffice.find(params[:id])
    veterinarian = @vet_office.veterinarians.new(vet_params)

    if veterinarian.save
      redirect_to "/veterinary_offices/#{@vet_office.id}/veterinarians"
    else
      redirect_to "/veterinary_offices/#{@vet_office.id}/veterinarians/new"
      flash[:alert] = "Error: #{error_message(veterinarian.errors)}"
    end
  end

  def edit
    @veterinarian = Veterinarian.find(params[:id])
  end

  def update
    veterinarian = Veterinarian.find(params[:id])
    if veterinarian.update_attributes(vet_params)
      redirect_to "/veterinarians/#{veterinarian.id}"
    else
      redirect_to "/veterinarians/#{veterinarian.id}/edit"
      flash[:alert] = "Error: #{error_message(veterinarian.errors)}"
    end
  end

  def destroy
    Veterinarian.find(params[:id]).destroy
    redirect_to '/veterinarians'
  end

  private

  def vet_params
    params.require(:veterinarian).permit(
      :name,
      :on_call,
      :review_rating,
      :veterinary_office_id
    )
  end
end
