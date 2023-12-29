# frozen_string_literal: true

# In this companies controller, admin can create the company
# Also Admin can see the specific company
# User can only see the all companies names and their locations

class CompaniesController < ApplicationController
  before_action :authorize_admin!, except: %i[index]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  # GET /companies
  def index
    companies = Company.all
    render json: companies, only: %i[name location]
  end

  # GET /companies/:id
  def show
    company = Company.find(params[:id])
    render json: company
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Company not found' }, status: :not_found
  end

  # POST /companies
  def create
    company = Company.new(company_params)
    company.user = current_user

    if company.save
      render json: company, status: :created
    else
      render json: { errors: company.errors }, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :location)
  end

  def authorize_admin!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user.admin?
  end

  def record_not_found
    render json: { error: 'Company not found' }, status: :not_found
  end

  def parameter_missing
    render json: { error: 'Missing parameters' }, status: :bad_request
  end
end
