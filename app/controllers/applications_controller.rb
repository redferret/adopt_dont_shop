class ApplicationsController < ApplicationController
  before_action :set_all_models, only: %i[ show edit update destroy ]

  def index
    @applications = Application.order(:status)
    render :index, location: applications_url, locals: {
      applications: @applications,
      normal_view: true
    }
  end

  def show
    render_show
  end

  def new
    @application = Application.new
  end

  def edit
  end

  def create
    @application = Application.new(description: '', status: 'In Progress')

    respond_to do |format|
      if @application.save(validate: false)
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
          format.html {render :new }
        else
          flash[:success] = 'Application was successfully created.'
          @pets_found = []
          format.html { render_show }
        end
      end
    end
  end

  def update
    if params[:pet_to_adopt]
      pet = Pet.find(params[:pet_to_adopt])

      if (!@application.pets.include?(pet))
        @application.pets << pet
        pet.update_status_for_application(params[:id], 'pending')
      end

      redirect_to application_path(params[:id])
    elsif params[:application][:search_pet_by]
      if params[:application][:search_pet_by].present?
        search_pet_by = params[:application][:search_pet_by]
        @pets_found = Pet.search(search_pet_by).where(adoptable: true)
      end
      render_show
    else
      respond_to do |format|
        if params[:application][:description].match(/^(\w+\s*\n*.*)+/)
          @application.update(application_params)
          @application.status = 'Pending'
          @application.save
          flash[:success] = 'Application submitted for review'
          format.html { redirect_to application_path(params[:id]) }
        else
          flash[:alert] = "Error: Description is needed to submit application"
          format.html { render_show }
        end
      end
    end
  end

  private

    def render_show
      render :show, location: @application, locals: {
        application: @application,
        pets_found: @pets_found,
        back_path: applications_path
      }
    end

    def set_application
      @application = Application.find(params[:id])
    end

    def set_all_models
      @application = set_application
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
