# This class is used to create invoices.
class InvoiceCreator
    def initialize(params={})
        @params = params
    end

    def call
        create_invoice
    end

    private

    def create_invoice
        Invoice.new(@params)
    end
end