class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[ show edit update destroy ]

  def index
    @applications = Application.all
  end

  def show
    @application = set_application
    @pets = @application.pets
    @applicant = @application.applicant
    @address = @applicant.address
  end

  def new
    @application = Application.new
  end

  def edit
    @application = set_application
  end

  def create
    check_application_status
    respond_to do |format|
      @application = Application.new(application_params)
      if @application.save
        @applicant = Applicant.new(applicant_params)

        if !@applicant.save
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @applicant.errors, status: :unprocessable_entity }
        end

        @address = Address.new(address_params)

        if !@address.save
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
        
        format.html { redirect_to @application, notice: "Application was successfully created." }
        format.json { render :show, status: :created, location: @application }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to @application, notice: "Application was successfully updated." }
        format.json { render :show, status: :ok, location: @application }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @application.destroy
    respond_to do |format|
      format.html { redirect_to applications_url, notice: "Application was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_application
      @application = Application.find(params[:id])
    end

    def check_application_status
      params[:application][:status] = 'In Progress' if not params[:application][:status].present?
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
