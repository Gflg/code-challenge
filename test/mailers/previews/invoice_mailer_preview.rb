# Preview all emails at http://localhost:3000/rails/mailers/invoice_mailer
class InvoiceMailerPreview < ActionMailer::Preview
    def welcome_email
        invoice = Invoice.find_by(id: 9)

        InvoiceMailer.with(invoice: invoice).welcome_email
    end
end
