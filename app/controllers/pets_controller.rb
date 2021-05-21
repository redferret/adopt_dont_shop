class PetsController < ApplicationController
  def index
    if params[:search].present?
      @pets = Pet.search(params[:search])
    else
      @pets = Pet.adoptable
    end
  end

  def show
    @pet = Pet.find(params[:id])
  end

  def new
    @shelter = Shelter.find(params[:id])
    @pet = Pet.new
  end

  def create
    shelter = Shelter.find(params[:id])
    pet = shelter.pets.new(pet_params)

    if pet.save
      redirect_to "/shelters/#{params[:id]}/pets"
    else
      redirect_to "/shelters/#{params[:id]}/pets/new"
      flash[:alert] = "Error: #{error_message(pet.errors)}"
    end
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    pet = Pet.find(params[:id])
    if pet.update_attributes(pet_params)
      redirect_to "/pets/#{pet.id}"
    else
      redirect_to "/pets/#{pet.id}/edit"
      flash[:alert] = "Error: #{error_message(pet.errors)}"
    end
  end

  def destroy
    Pet.find(params[:id]).destroy
    redirect_to '/pets'
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :age, :breed, :adoptable, :shelter_id)
  end
end
