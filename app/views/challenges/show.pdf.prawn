prawn_document(page_size: "A4") do |pdf|
  pdf.text "Sodbury Challenge", align: :center, style: :bold, size: 18
  pdf.move_down 12

  pdf.table([ ["Team Number:", "Team Name:"],
              ["Start Time:", ""],
              ["Due Finish Time:", "Finish Time:"],
              ["Due Phone In Time:", "Phone In Time:"]
            ], :width => 525, :cell_style => { :border_width => 0 }
            )

  pdf.move_down 50

  pdf.text "Emergency Number: 01234567890", align: :center, style: :bold, size: 14
  pdf.text "Phone in Number: 01234567890", align: :center, style: :bold, size: 14


end
