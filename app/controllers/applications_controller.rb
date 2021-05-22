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
      @application = Application.new(description:'', status: 'In Progress')
      if @application.save
        @applicant = Applicant.new(applicant_params)

        if !@applicant.save
          @application.delete
          flash[:alert] = "Error: #{error_message(@applicant.errors)}"
          format.html { render :new, status: :unprocessable_entity }
        end

        @address = Address.new(address_params)

        if !@address.save
          @application.delete
          @applicant.delete
          flash[:alert] = "Error: #{error_message(@address.errors)}"
          format.html { render :new, status: :unprocessable_entity }
        else
          format.html { redirect_to @application, notice: "Application was successfully created." }
        end
      else
        flash[:alert] = "Error: #{error_message(@application.errors)}"
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:application][:search_pet_by].present?
      search_pet_by = params[:application][:search_pet_by]
      @pets_found = Pet.search(search_pet_by)
      render :show, status: :ok, location: @application
    else
      respond_to do |format|
        if @application.update(application_params)
          if !@applicant.update(applicant_params)
            flash[:alert] = "Error: #{error_message(@applicant.errors)}"
            format.html { render :edit, status: :unprocessable_entity }
          end

          if !@address.update(address_params)
            flash[:alert] = "Error: #{error_message(@address.errors)}"
            format.html { render :edit, status: :unprocessable_entity }
          else
            format.html { render :show, status: :ok, location: @application }
          end
        else
          flash[:alert] = "Error: #{error_message(@application.errors)}"
          format.html { render :new, status: :unprocessable_entity }
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
