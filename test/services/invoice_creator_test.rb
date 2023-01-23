require "test_helper"

class InvoiceCreatorTest < ActionDispatch::SystemTestCase
    test "create invoice" do
        invoice_params = {
            id: 10,
            created_at: Time.now.to_date,
            company: "test company",
            debtor: "test debtor",
            total_value: 20.54,
        }
        invoice = InvoiceCreator.new(invoice_params).call

        assert invoice.id == invoice_params[:id]
        assert invoice.created_at == invoice_params[:created_at]
        assert invoice.company == invoice_params[:company]
        assert invoice.debtor == invoice_params[:debtor]
        assert invoice.total_value == invoice_params[:total_value]
    end
end