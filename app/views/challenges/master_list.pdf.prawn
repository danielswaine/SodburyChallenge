prawn_document(page_size: "A4", page_layout: :landscape) do |pdf|

  challenge_date = params[:date]

  pdf.text "Sodbury Challenge #{Date.parse(challenge_date).year} - Master Checkpoint List", align: :center, style: :bold, size: 24

  pdf.table(
            [["No.", "Grid Ref", "Description"]],
            width: 800, column_widths: [50, 100, 650], position: :center, cell_style: { font_style: :bold, border_color: 'DDDDDD', background_color: 'DDDDDD' }
            )

  checkpoints = []
  @challenges.where(date: challenge_date).each do |challenge|
    challenge.goals.each do |goal|
      checkpoints.push(
        [
          goal.checkpoint.number,
          goal.checkpoint.grid_reference,
          goal.checkpoint.description
          #goal.challenge.time_allowed
        ]
      )
    end
  end
  counts = Hash.new 0
  checkpoints.each do |c|
    counts[c] += 1
  end
  #pdf.text "#{checkpoints}"

  checkpoints = checkpoints.uniq
  checkpoints.uniq do |goal|
    pdf.table(
    [[goal[0], goal[1], goal[2]]],
    :width => 800, column_widths: [50, 100, 650], row_colors: ["FFFFFF", "F9F9F9"], :position => :center, :cell_style => { :border_color => "DDDDDD" }
    )
  end

end
