prawn_document(page_size: "A4") do |pdf|

  ncolumns = 8
  nrows = 15
  gutter = 0

  pdf.define_grid(:columns => ncolumns, :rows => nrows, :gutter => gutter)
  #pdf.grid.show_all

  row_location = [1, 8]
  title_location = [0, 7]

  row_location.each_with_index do |row, title|
    pdf.grid([title_location[title], 0], [title_location[title], 7]).bounding_box do
      pdf.draw_text "Sodbury Challenge #{@challenge.date.strftime('%Y')} - #{@challenge.time_allowed} Hour - Clipper Sheet", at: [10, 10], valign: :bottom, size: 22, style: :bold
    end

    x = row; y = 0
    rows = @challenge.goals.where(start_point: false).map do |goal|
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
  #pdf.grid.show_all

  row_location.each_with_index do |row, title|
    pdf.grid([title_location[title], 0], [title_location[title], 7]).bounding_box do
      pdf.draw_text "Team Number:", at: [10, 10], size: 12, style: :bold
    end
    pdf.grid([title_location[title], 3], [title_location[title], 7]).bounding_box do
      pdf.draw_text "Team Name:", at: [10, 10], size: 12, style: :bold
    end
    pdf.grid([title_location[title] + 1, 0], [title_location[title], 7]).bounding_box do
      pdf.draw_text "Start Time:", at: [10, 10], size: 12, style: :bold
    end
    pdf.grid([title_location[title] + 1, 3], [title_location[title], 7]).bounding_box do
      pdf.draw_text "Due Phone In Time:", at: [10, 10], size: 12, style: :bold
    end
    pdf.grid([title_location[title] + 2, 0], [title_location[title], 7]).bounding_box do
      pdf.draw_text "Due Finish Time:", at: [10, 10], size: 12, style: :bold
    end
    pdf.grid([title_location[title] + 2, 3], [title_location[title], 7]).bounding_box do
      pdf.draw_text "Actual Finish Time:", at: [10, 10], size: 12, style: :bold
    end
  end

end