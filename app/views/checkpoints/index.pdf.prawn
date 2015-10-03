prawn_document(page_size: "A4") do |pdf|
  pdf.text "Sodbury Challenge Master Checkpoint List", align: :center, style: :bold, size: 18
  pdf.move_down 12
  pdf.text "Exported at #{Time.now.strftime("%R on %-d %B %Y")} by #{current_user.name}. Do not distribute.",
            align: :center, size: 14

  pdf.move_down 18
  pdf.text "Num    Grid Ref             Description", style: :bold, leading: 6
  @checkpoints.each do |checkpoint|
    pdf.text "#{checkpoint.number}          #{checkpoint.grid_reference}          #{checkpoint.description}",
              leading: 6
  end
end
