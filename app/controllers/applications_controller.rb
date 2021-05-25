class ApplicationsController < ApplicationController
  before_action :set_all_models, only: %i[ show edit update destroy ]

  def index
    @applications = Application.all
  end

  def show
  end

  def new
    @application = Application.new
  end

  def edit
  end

  def create
    respond_to do |format|
      @application = Application.new(description: '', status: 'In Progress')
      if @application.save
        @applicant = Applicant.new(applicant_params)

        if !@applicant.save
          @application.delete
          flash[:alert] = "Error: #{error_message(@applicant.errors)}"
          format.html { render :new }
        end

        @address = Address.new(address_params)

        if !@address.save
          @application.delete
          @applicant.delete
          flash[:alert] = "Error: #{error_message(@address.errors)}"
          format.html { render :new }
        else
          flash[:success] = 'Application was successfully created.'
          format.html { redirect_to @application}
        end
      end
    end
  end

  def update
    if params[:pet_to_adopt].present?
      pet_id = params[:pet_to_adopt][:pet_id]
      pet = Pet.find(pet_id)

      if (!@application.pets.include?(pet))
        @application.pets << pet
      end

      render :show, status: :ok, location: @application
    elsif params[:application][:search_pet_by]
      if params[:application][:search_pet_by].present?
        search_pet_by = params[:application][:search_pet_by]
        @pets_found = Pet.search(search_pet_by).where(adoptable: true)
      end
      render :show, location: @application
    else
      respond_to do |format|
        if params[:application][:description].match(/^(\w+\s*\n*.*)+/)
          @application.update(application_params)
          @application.status = 'Pending'
          @application.save
          flash[:success] = 'Application submitted for review'
          format.html { render :show, location: @application }
        else
          flash[:alert] = "Error: Description is needed to submit application"
          format.html { render :show }
        end
      end
    end
  end

  def destroy
    @application.destroy
    respond_to do |format|
      format.html { redirect_to applications_url, notice: "Application was successfully destroyed." }
    end
  end

  private
    def set_application
      @application = Application.find(params[:id])
    end

    def set_all_models
      @application = set_application
      @pets = @application.pets
      @applicant = @application.applicant
      @address = @applicant.address
      @pets_found = []
    end

    def address_params
      params[:address][:applicant_id] = @applicant.id if not params[:address][:applicant_id].present?
      params.require(:address).permit(:street, :city, :state, :zipcode, :applicant_id)
    end

    def applicant_params
      params[:applicant][:application_id] = @application.id if not params[:applicant][:application_id].present?
      params.require(:applicant).permit(:name, :application_id)
    end

    def application_params
      params.require(:application).permit(:description, :status)
    end
end
