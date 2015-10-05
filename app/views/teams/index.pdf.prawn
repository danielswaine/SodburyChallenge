prawn_document(page_size: "A4", :page_layout => :landscape) do |pdf|
  pdf.text "Sodbury Challenge Start Times", align: :center, style: :bold, size: 18
  pdf.move_down 12
  pdf.text "Exported at #{Time.now.strftime("%R on %-d %B %Y")} by #{current_user.name}",
          align: :center, size: 14

  pdf.move_down 18
  # table(data, options)
  pdf.table(
    [["No.", "Team Name", "Start Time", "Phone In", "Finish Time"]],
    :width => 750, :column_widths => [50, 460, 80, 80, 80],  :position => :center,
		:cell_style => { :font_style => :bold, :border_color => "DDDDDD", :background_color => "DDDDDD" }
  )
  count = 0
  pdf.table(
    @teams.map{ |team|
      count += 1
      [count, team.name, team.nominal_start_time, phone_in_time(team), finish_time(team)]
    },
    :width => 750, :row_colors => ["FFFFFF", "F9F9F9"], :cell_style => {:border_color => "DDDDDD"},
		:column_widths => [50, 460, 80, 80, 80],  :position => :center
  )
end
