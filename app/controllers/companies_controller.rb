class CompaniesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    policy_scope(Company)
    if params[:query].present?
      results = PgSearch.multisearch(params[:query])
      @companies = []
      results.each do |result|
        @companies << result.searchable
      end
    else
      @companies = Company.all
    end
  end

  def show
    authorize @company
  end

  def new
    @company = Company.new
    authorize @company
  end

  def create
    @company = Company.new(company_params)
    @company.user = current_user
    authorize @company
    if @company.save
      redirect_to company_path(@company)
    else
      render :new
    end
  end

  def edit
    # only authorization for the admin
  end

  def update
    # only authorization for the admin
    @company.update(company_params)
    redirect_to company_path(@company)
  end

  def destroy
    # only authorization for the admin
  end

  protected

  def set_company
    @company = Company.find(params[:id])
    authorize @company

  def company_params
    params.require(:company).permit(:name, :photo, :photo_cache, :email, :url, :category)
  end
end

