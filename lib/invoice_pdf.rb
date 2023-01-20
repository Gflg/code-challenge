class InvoicePdf < Prawn::Document
    def call
        draw_pdf
    end

    def draw_pdf
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

        pdf
    end

    def invoice
        params[:invoice]
    end
end