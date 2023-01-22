class ExportPdf
    include Prawn::View
  
    def initialize(invoice)
        @invoice = invoice
        content
    end
  
    def content
        pdf = Prawn::Document.new
        pdf.text "aaaaaaaa"
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

        pdf
    end
  end