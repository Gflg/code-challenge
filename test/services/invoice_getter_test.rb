require "test_helper"

class InvoiceGetterTest < ActionDispatch::SystemTestCase
    test "find invoice by id" do
        invoice = invoices(:one)
        params = {
            id: 1
        }
        invoice_getter = InvoiceGetter.new(params)
        found_invoice = invoice_getter.find_invoice_by_id

        assert invoice.id == found_invoice.id
        assert invoice.created_at == found_invoice.created_at
        assert invoice.company == found_invoice.company
        assert invoice.debtor == found_invoice.debtor
        assert invoice.total_value == found_invoice.total_value
    end

    test "get all invoices without filters" do
        invoice_getter = InvoiceGetter.new
        all_invoices = invoice_getter.filter_all_invoices

        #There are 2 invoices created in invoices.yml
        assert all_invoices.count == 2
    end

    test "get all invoices with id filter" do
        invoice = invoices(:two)
        invoice_getter = InvoiceGetter.new(id: 2)
        all_invoices = invoice_getter.filter_all_invoices

        assert all_invoices.count == 1
        assert invoice.id == all_invoices[0].id
        assert invoice.created_at == all_invoices[0].created_at
        assert invoice.company == all_invoices[0].company
        assert invoice.debtor == all_invoices[0].debtor
        assert invoice.total_value == all_invoices[0].total_value
    end

    test "get all invoices with start_date filter" do
        invoice_getter = InvoiceGetter.new(start_date: "2022-01-01")
        all_invoices = invoice_getter.filter_all_invoices

        assert all_invoices.count == 2
    end

    test "get all invoices with end_date filter" do
        invoice_getter = InvoiceGetter.new(end_date: "2023-01-22")
        all_invoices = invoice_getter.filter_all_invoices

        assert all_invoices.count == 2
    end

    test "get first invoice with start_date and end_date filters" do
        invoice = invoices(:one)
        invoice_getter = InvoiceGetter.new(start_date: "2022-01-01", end_date: "2023-01-01")
        all_invoices = invoice_getter.filter_all_invoices

        assert all_invoices.count == 1
        assert invoice.id == all_invoices[0].id
        assert invoice.created_at == all_invoices[0].created_at
        assert invoice.company == all_invoices[0].company
        assert invoice.debtor == all_invoices[0].debtor
        assert invoice.total_value == all_invoices[0].total_value
    end

    test "get second invoice with id, start_date and end_date filters" do
        invoice = invoices(:two)
        invoice_getter = InvoiceGetter.new(id: 2, start_date: "2022-01-01", end_date: "2023-01-22")
        all_invoices = invoice_getter.filter_all_invoices

        assert all_invoices.count == 1
        assert invoice.id == all_invoices[0].id
        assert invoice.created_at == all_invoices[0].created_at
        assert invoice.company == all_invoices[0].company
        assert invoice.debtor == all_invoices[0].debtor
        assert invoice.total_value == all_invoices[0].total_value
    end
end