prawn_document(page_size: "A4") do |pdf|

  ncolumns = 8
  nrows = 15
  gutter = 0

  goals = @challenge.goals.where(start_point: false)

  # The number of rows required to display all the checkpoints
  ncheckpointrows = (goals.size.to_f / ncolumns.to_f).ceil

  # The number of rows required for one clipper
  # +3 for one header row and two gaps
  nclipperrows = ncheckpointrows + 3

  pdf.define_grid(:columns => ncolumns, :rows => nrows, :gutter => gutter)
  # pdf.grid.show_all

  clipper_locations = (0..(nrows - nclipperrows)).step(nclipperrows).to_a

  clipper_locations.each_with_index do |row, title|
    pdf.grid([row, 0], [row, ncolumns - 1]).bounding_box do
      pdf.draw_text "Sodbury Challenge #{@challenge.date.strftime('%Y')} - #{@challenge.time_allowed} Hour - Clipper Sheet", at: [10, 10], valign: :bottom, size: 22, style: :bold
    end

    x = row + 1; y = 0
    rows = goals.map do |goal|
      {
        checkpoint: goal.checkpoint.number,
      }
    end
    rows.sort_by! { |row| row[:checkpoint] }.each do |goal|
      pdf.grid(x, y).bounding_box do
        pdf.stroke_bounds
        pdf.draw_text "#{goal[:checkpoint]}", at: [2, 40]
        y += 1;
        if y == 8 then x += 1; y = 0 end
      end
    end
  end

  pdf.start_new_page
  pdf.define_grid(:columns => ncolumns, :rows => nrows, :gutter => gutter)
  # pdf.grid.show_all

  clipper_locations.each_with_index do |row, title|
    pdf.grid([row, 0], [row, 3]).bounding_box do
      pdf.draw_text "Team Number:", at: [10, 10], size: 12, style: :bold
    end
    pdf.grid([row, 3], [row, ncolumns - 1]).bounding_box do
      pdf.draw_text "Team Name:", at: [10, 10], size: 12, style: :bold
    end
    pdf.grid([row + 1, 0], [row + 1, 3]).bounding_box do
      pdf.draw_text "Start Time:", at: [10, 10], size: 12, style: :bold
    end
    pdf.grid([row + 1, 3], [row + 1, ncolumns - 1]).bounding_box do
      pdf.draw_text "Due Phone In Time:", at: [10, 10], size: 12, style: :bold
    end
    pdf.grid([row + 2, 0], [row + 2, 3]).bounding_box do
      pdf.draw_text "Due Finish Time:", at: [10, 10], size: 12, style: :bold
    end
    pdf.grid([row + 2, 3], [row + 2, ncolumns - 1]).bounding_box do
      pdf.draw_text "Actual Finish Time:", at: [10, 10], size: 12, style: :bold
    end
  end

end
