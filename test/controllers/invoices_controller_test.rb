require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get invoices_url
    assert_response :success
  end

  test "should get index with id filter" do
    get invoices_url(id: 1)
    assert_response :success
  end

  test "should get index with date filter" do
    get invoices_url(start_date: Time.now.to_date)
    assert_response :success
  end

  test "should get index with id and date filter" do
    get invoices_url(id: 2, start_date: Time.now.to_date)
    assert_response :success
  end

  test "should get new" do
    get new_invoice_url
    assert_response :success
  end

  test "should create invoice" do
    assert_difference("Invoice.count") do
      post invoices_url, params: { invoice: { company: @invoice.company, debtor: @invoice.debtor, total_value: @invoice.total_value } }
    end

    assert_redirected_to invoice_url(Invoice.last)
  end

  test "should show invoice" do
    get invoice_url(@invoice)
    assert_response :success
  end

  test "should get edit" do
    get edit_invoice_url(@invoice)
    assert_response :success
  end

  test "should update invoice" do
    patch invoice_url(@invoice), params: { invoice: { company: @invoice.company, debtor: @invoice.debtor, total_value: @invoice.total_value } }
    assert_redirected_to invoice_url(@invoice)
  end

end
