class AsmMailer < ActionMailer::Base

  default from: "no-reply@manaple.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.thankyou.subject
  #

  def print_hyphen_if_empty(value)
    if value.blank?
      "-"
    else
      value
    end
  end

  def store_opened(store,opening_time)
    @opening_time = opening_time
    @store = store
    if store.users_who_should_receive_store_opening_mail != nil
      users = store.users_who_should_receive_store_opening_mail
      emails = users.collect(&:email).join(",")
      mail to: emails, subject: "Store Opened"
    end
  end

  def leave_request_created(leave)
    @leave = leave
    @employee = @leave.user
    store = @employee.store
    if store.users_who_should_receive_leave_request_mail != nil
      users = store.users_who_should_receive_leave_request_mail
      emails = users.collect(&:email).join(",")
      mail to: emails, subject: @employee.name+" has applied for Leave"
    end
  end

  def specific_date_notification(user, date)
    @incharge = user
    @date = date
    @stores = @incharge.stores
    @attendance_data_all = []    
    @stores.each do |store|
      @attendance_data_all = @attendance_data_all + store.attendance_data_for(@date) 
    end    
    @attendance_data_all.sort_by!{|attendance_data| [attendance_data['store'].name,attendance_data['employee'].name.capitalize]}
    mail to: @incharge.email, subject: "Attendance at your Stores"
  end
end
