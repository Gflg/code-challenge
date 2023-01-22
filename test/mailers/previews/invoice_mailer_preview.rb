# Preview all emails at http://localhost:3000/rails/mailers/invoice_mailer
class InvoiceMailerPreview < ActionMailer::Preview
    def invoice_created
        invoice = Invoice.find_by(id: 1)

        InvoiceMailer.with(invoice: invoice).invoice_created
    end
end
