prawn_document(page_size: "A4") do |pdf|
  pdf.text "Sodbury Challenge Master Checkpoint List", align: :center, style: :bold, size: 18
  pdf.move_down 12
  pdf.text "Exported on #{Time.now.strftime("%-d %B %Y at %R")} by #{current_user.name}. Do not distribute.", align: :center, size: 14
end
