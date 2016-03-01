prawn_document(page_size: "A4") do |pdf|
  pdf.text "Sodbury Challenge #{@challenge.date.strftime('%Y')} - #{@challenge.time_allowed} Hour", align: :center, style: :bold, size: 24

  pdf.move_down 20

  pdf.table([ ["Team Number:", "Team Name:"],
              ["Start Time:", ""],
              ["Due Finish Time:", "Finish Time:"],
              ["Due Phone In Time:", "Phone In Time:"]
            ], :width => 525, :cell_style => { :border_width => 0 }
            )

  pdf.move_down 20

  pdf.table(
		[["", "Checkpoint", "Grid Reference", "Score"]],
		:width => 524, :column_widths => [131,131,131,131],  :position => :center,
		:cell_style => { :align => :center, :font_style => :bold, :border_color => "DDDDDD", :background_color => "DDDDDD" }
	)

  pdf.table(
		@goals.order(start_point: :DESC, compulsory: :DESC).collect{ |goal|
			[
        if goal.start_point?
          "Start"
        elsif goal.compulsory?
          "Compulsory"
        end,
        goal.checkpoint_id,
        goal.checkpoint.grid_reference,
        goal.points_value
      ]
		},
		:width => 524, :row_colors => ["FFFFFF", "F9F9F9"], :cell_style => {:border_color => "DDDDDD", :align => :center},
		:column_widths => [131,131,131,131],  :position => :center
	)

  pdf.table(
    [["Finish (Scout Hut)", "-", "7275-8265", "-"]],
    :width => 524, :column_widths => [131,131,131,131],  :position => :center,
    :cell_style => { :align => :center, :border_color => "DDDDDD"}
  )

  pdf.move_down 20

  pdf.text "Emergency Number: 01234567890", align: :center, style: :bold, size: 14
  pdf.text "Phone in Number: 01234567890", align: :center, style: :bold, size: 14

  pdf.move_down 20

  pdf.table(
    [["Points Calculation", ""]],
		:width => 524, :column_widths => [523, 1], :position => :center,
		:cell_style => { :align => :center, :font_style => :bold, :border_color => "DDDDDD", :background_color => "DDDDDD" }
	)
  pdf.table(
    [
      ["Total visited checkpoints", ""],
      ["Phone call on time bonus (30 points, -1 for every minute early or late)", ""],
      ["Bonus for not being late back (30 points, -1 for every minutes late up to -30)", ""],
    ],
    :width => 524, :column_widths => [430, 94], :position => :center,
    :cell_style => { :align => :left, :border_color => "DDDDDD" }
  )
  pdf.table(
    [
      ["Total Points", ""]
    ],
    :width => 524, :column_widths => [430, 94], :position => :center,
    :cell_style => { :align => :right, :font_style => :bold, :border_color => "DDDDDD" }
  )
end
