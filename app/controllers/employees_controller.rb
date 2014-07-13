class EmployeesController < ApplicationController

  before_filter :authenticate_user!
  def list
    @employee_code_enabled = current_user.stores.first.employee_code_enabled
    @employee_designation_enabled = current_user.stores.first.employee_designation_enabled
    @all_stores = current_user.stores
    @stores_to_display = params[:stores].present? ? get_stores_to_display : @all_stores
    @employees_to_display = []
    @stores_to_display.each do |store|
      @employees_to_display << store.all_employees
    end
    @employees_to_display.flatten!
    @employees_to_display_paginated = Kaminari.paginate_array(@employees_to_display).page(params[:page]).per(30)
  end

  def create
    name = params[:employee_name]
    employee_code = params[:employee_code]
    employee_designation = params[:employee_designation]
    store_name = params[:store_name]
    store = Store.where(name: store_name).first
    email = name.delete(' ').downcase
    email << "@manaple.com"
    while User.where(email: email).present? do
      email = name.delete(' ').downcase
      email << (0...4).map { ('a'..'z').to_a[rand(26)] }.join
      email << "@manaple.com"
    end
    user = User.create!(name: name, email: email, :password => Devise.friendly_token[0,20], employee_code: employee_code, employee_designation: employee_designation)
    Authorization.create(user_id: user.id, store_id: store.id, permission: "staff" )
    redirect_to(:controller => 'employees', :action => 'list')
  end

  def new
    @stores = current_user.stores
    @employee_code_enabled = @stores.first.employee_code_enabled
    @employee_designation_enabled = @stores.first.employee_designation_enabled
  end


  def transfer
    @stores = current_user.stores
    @employees = []
    @stores.each do |store|
      @employees << store.employees
    end
    @employees.flatten!
    @employee_code_enabled = @stores.first.employee_code_enabled
    @employee_designation_enabled = @stores.first.employee_designation_enabled
  end

  def edit
    unless current_user.can('access_employee',params[:employee_id])
      render :status => :unauthorized
      return
    end     
    @employee = User.find(params[:employee_id])         
    @employee_code_enabled = @employee.store.employee_code_enabled
    @employee_designation_enabled = @employee.store.employee_designation_enabled
  end

  def update
    if current_user.can('access_employee',employee_params[:id])
      employee = User.find(employee_params[:id])    
      if employee.update(employee_params)
        redirect_to employees_list_path
      else
        flash[:error] = "Could not save data"
        render "edit"
      end
    else
      render :status => :unauthorized
      return
    end
  end

  def update_store
    if current_user.can('access_employee',employee_params[:id])
      employee = User.find(employee_params[:id])    
      authorization = employee.authorizations.find_by! store_id: employee_params[:from_store]
      authorization.store_id = employee_params[:destination_store]
      if authorization.save
        flash[:notice] = "Employee Store Updated"
        redirect_to employees_list_path
      else
        flash[:error] = "Could not save data"
        render "transfer"
      end
    else
      render :status => :unauthorized
      return
    end
  end



  private

  def employee_params
    params.require(:employee).permit(:id,:name, :employee_code, :employee_designation, :employee_status, :store, :from_store,:destination_store)
  end
end