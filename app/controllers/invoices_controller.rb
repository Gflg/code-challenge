class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]

  # GET /invoices or /invoices.json
  def index
    if is_param_set(id)
      @invoices = Invoice.where(id: id)
    elsif is_param_set(start_date) && is_param_set(end_date)
      @invoices = Invoice.where("created_at >= (?) AND created_at <= (?)", start_date, end_date)
    elsif is_param_set(start_date)
      @invoices = Invoice.where("created_at >= (?)", start_date)
    elsif is_param_set(end_date)
      @invoices = Invoice.where("created_at <= (?)", end_date)
    else
      @invoices = Invoice.all
    end
  end

  # GET /invoices/1 or /invoices/1.json
  def show
    @invoice = Invoice.find(id)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = create_pdf
        send_data pdf.render, filename: "invoice_#{@invoice.id}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def edit_emails
    @invoice = Invoice.find(id)
  end

  def save_emails
    respond_to do |format|
      if @invoice.update(invoice_params)
        InvoiceMailer.with(invoice: @invoice).welcome_email.deliver_later
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice emails were successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @emails = @invoice.emails.build
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    respond_to do |format|
      if Invoice.find_by(id: @invoice.id).nil?
        if @invoice.save
          InvoiceMailer.with(invoice: @invoice).welcome_email.deliver_later
          format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully created and mails were sent." }
          format.json { render :show, status: :created, location: @invoice }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        @invoice.errors[:id] << "ID already exists!"
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        InvoiceMailer.with(invoice: @invoice).welcome_email.deliver_later
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully created and mails were sent." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(id)
    end

    def id
      params[:id]
    end

    def start_date
      params[:start_date]
    end

    def end_date
      params[:end_date]
    end

    def is_param_set(param)
      !param.nil? && param != ""
    end

    def create_pdf
      pdf = Prawn::Document.new
      pdf.text "ID: #{@invoice.id}"
      pdf.move_down 10
      pdf.text "Creation date: #{@invoice.created_at.strftime('%d-%m-%Y')}"
      pdf.move_down 10
      pdf.text "Company: #{@invoice.company}"
      pdf.move_down 10
      pdf.text "Debtor: #{@invoice.debtor}"
      pdf.move_down 10
      pdf.text "Total value: $#{@invoice.total_value}"
      pdf.move_down 10
      pdf.text "Emails"
      @invoice.emails.each do |email|
        pdf.move_down 10
        pdf.text "#{Prawn::Text::NBSP * 5}• #{email.address}"
      end
  
      pdf
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(:id,
        :created_at,
        :company,
        :debtor,
        :total_value,
        :start_date,
        :end_date,
        emails_attributes: [
          :id,
          :address,
          :_destroy
        ],
      )
    end
end
