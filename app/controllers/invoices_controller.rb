class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update ]

  # GET /invoices or /invoices.json
  # Used to show all invoices created based on filters defined in params variable
  def index
    @invoices = InvoiceFinder.new(params.merge(filter_all_invoices: true)).call
  end

  # GET /invoices/1 or /invoices/1.json
  # Used to show details from a specific invoice
  def show
    @invoice = InvoiceFinder.new(params).call
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

  # GET /invoices/new
  # Used to load creation page
  def new
    @invoice = Invoice.new
    @emails = @invoice.emails.build
  end

  # GET /invoices/1/edit
  # Used to load edition page
  def edit
  end

  # POST /invoices or /invoices.json
  # Used to save data from a new invoice
  # It doesn't allow the creation of invoices with the same ID of a previous one
  # It also sends an email to all the emails linked to the current invoice
  def create
    @invoice = InvoiceCreator.new(invoice_params).call
    respond_to do |format|
      if InvoiceFinder.new({id: @invoice.id}).call.nil?
        if @invoice.save
          InvoiceMailer.with(invoice: @invoice).invoice_created.deliver_later
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
  # Saves changes to a existing invoice
  # It also sends an email to all the emails linked to the current invoice
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        InvoiceMailer.with(invoice: @invoice).invoice_created.deliver_later
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice emails were successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
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
