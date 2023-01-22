class InvoiceHandler
    def initialize(params={})
        @invoice_id = params[:id]
        @start_date = params[:start_date]
        @end_date = params[:end_date]
        @params = params
    end

    def find_invoice_by_id
        Invoice.find_by_id(@invoice_id)
    end

    def filter_all_invoices
        invoices = Invoice.all
        if is_param_set(@invoice_id)
          invoices = invoices.where(id: @invoice_id)
        end
        if is_param_set(@start_date) && is_param_set(@end_date)
          invoices = invoices.where("created_at >= (?) AND created_at <= (?)", @start_date, @end_date)
        elsif is_param_set(@start_date)
          invoices = invoices.where("created_at >= (?)", @start_date)
        elsif is_param_set(@end_date)
          invoices = invoices.where("created_at <= (?)", @end_date)
        end

        invoices
    end

    def create_invoice
      Invoice.new(@params)
    end

    private

    def is_param_set(param)
        !param.nil? && param != ""
    end
end