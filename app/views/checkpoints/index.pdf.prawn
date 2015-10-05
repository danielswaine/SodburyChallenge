prawn_document(page_size: "A4") do |pdf|
	pdf.text "Sodbury Challenge Master Checkpoint List", align: :center, style: :bold, size: 18
	pdf.move_down 12
	pdf.text "Exported at #{Time.now.strftime("%R on %-d %B %Y")} by #{current_user.name}. Do not distribute.",
	        align: :center, size: 14

	pdf.move_down 18

	pdf.table(
		[["No.", "Grid Reference", "Description"]],
		:width => 525, :column_widths => [30, 100, 395],  :position => :center,
		:cell_style => { :font_style => :bold, :border_color => "DDDDDD", :background_color => "DDDDDD" }
	)
	pdf.table(
		@checkpoints.collect{ |checkpoint|
			[checkpoint.number, checkpoint.grid_reference, checkpoint.description]
		},
		:width => 525, :row_colors => ["FFFFFF", "F9F9F9"], :cell_style => {:border_color => "DDDDDD"},
		:column_widths => [30, 100, 395],  :position => :center
	)
end
