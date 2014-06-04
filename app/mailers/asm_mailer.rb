class AsmMailer < ActionMailer::Base

  default from: "no-reply@manaple.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.thankyou.subject
  #
  def notification(incharge)
  	@incharge = incharge
    @stores = incharge.stores
    @store = incharge.store
    mail to: @store.email, subject: "Attendance at your Stores"
  end

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
    if store.incharge != nil
      @incharge = store.incharge
      mail to: @store.email, subject: "Store Opened"
    end
  end

  def leave_request_created(leave)
    @leave = leave
    @employee = @leave.user
    store = @employee.store
    if store.incharge != nil
      @incharge = store.incharge
      mail to: store.email, subject: @employee.name+" has applied for Leave"
    end
  end
end
