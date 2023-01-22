class InvoiceCreator
    def initialize(params)
        @params = params
    end

    def create_invoice
        Invoice.new(@params)
    end
end