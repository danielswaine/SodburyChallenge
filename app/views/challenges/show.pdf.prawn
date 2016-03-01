prawn_document(page_size: "A4") do |pdf|
  pdf.text "Sodbury Challenge #{@challenge.date.strftime('%Y')} - #{@challenge.time_allowed} Hour", align: :center, style: :bold, size: 18
  pdf.move_down 12

  pdf.table([ ["Team Number:", "Team Name:"],
              ["Start Time:", ""],
              ["Due Finish Time:", "Finish Time:"],
              ["Due Phone In Time:", "Phone In Time:"]
            ], :width => 525, :cell_style => { :border_width => 0 }
            )

  pdf.move_down 20

  pdf.table(
		[["", "Checkpoint", "Grid Reference", "Score"]],
		:width => 525, :column_widths => [131],  :position => :center,
		:cell_style => { :font_style => :bold, :border_color => "DDDDDD", :background_color => "DDDDDD" }
	)

  pdf.table(
		@goals.collect{ |goal|
			[(goal.compulsory? && "Compulsory") || "", goal.checkpoint_id, goal.checkpoint.grid_reference, goal.points_value]
		},
		:width => 525, :row_colors => ["FFFFFF", "F9F9F9"], :cell_style => {:border_color => "DDDDDD"},
		:column_widths => [131],  :position => :center
	)

  pdf.move_down 20

  pdf.text "Emergency Number: 01234567890", align: :center, style: :bold, size: 14
  pdf.text "Phone in Number: 01234567890", align: :center, style: :bold, size: 14
end
