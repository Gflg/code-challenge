class InvoiceGetter
    def initialize(filters={})
        @invoice_id = filters[:id]
        @start_date = filters[:start_date]
        @end_date = filters[:end_date]
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

    private

    def is_param_set(param)
        !param.nil? && param != ""
    end
end