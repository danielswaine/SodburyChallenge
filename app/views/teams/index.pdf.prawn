prawn_document(page_size: "A4", :page_layout => :landscape) do |pdf|
  pdf.text "Sodbury Challenge Start Times", align: :center, style: :bold, size: 18
  pdf.move_down 12
  pdf.text "Exported at #{Time.now.strftime("%R on %-d %B %Y")} by #{current_user.name}",
          align: :center, size: 14

  pdf.move_down 18

  count = 1
  @challenges.order(:time_allowed).each do |challenge|
    pdf.text  "#{challenge.time_allowed} Hour Challenge", align: :center, size:16
    pdf.move_down 18
    pdf.table(
      [["No.", "Team Name", "Start Time", "Phone In", "Finish Time"]],
      :width => 750, :column_widths => [50, 460, 80, 80, 80],  :position => :center,
  		:cell_style => { :font_style => :bold, :border_color => "DDDDDD", :background_color => "DDDDDD" }
    )
    challenge.teams.order(:nominal_start_time).each do |team|
      pdf.table(
        [[count, team.name, team.nominal_start_time, phone_in_time(team), finish_time(team)]],
        :width => 750, :row_colors => ["FFFFFF", "F9F9F9"], :position => :center,
        :column_widths => [50, 460, 80, 80, 80], :cell_style => { :border_color => "DDDDDD" }
      )
      count += 1
    end
    pdf.move_down 18
  end
end
