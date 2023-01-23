class InvoiceMailer < ApplicationMailer
    default from: 'code_challenge_invoices@test.com'

    def invoice_created
        @invoice = params[:invoice]
        @url  = 'http://example.com/login'
        attachments["invoice.pdf"] = generate_pdf_content
        all_emails = @invoice.emails.map {|mail| mail.address}
        mail(to: all_emails, subject: 'Your invoice was created sucessfully')
    end

    private

    def generate_pdf_content
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

        pdf.render
    end
end
