prawn_document(page_size: "A4") do |pdf|
  pdf.text "Sodbury Challenge #{@challenge.date.strftime('%Y')} - #{@challenge.time_allowed} Hour", align: :center, style: :bold, size: 24

  pdf.move_down 20

  pdf.table(
            [
              ["Team Number:", "Team Name:"],
              ["Start Time:", ""],
              ["Due Finish Time:", "Finish Time:"],
              ["Due Phone In Time:", "Phone In Time:"]
            ], width: 525, cell_style: { border_width: 0 }
            )

  pdf.move_down 20

  pdf.table(
            [["", "Checkpoint", "Grid Reference", "Score"]],
            width: 524, column_widths: [131, 131, 131, 131],
            position: :center, cell_style: { align: :center, font_style: :bold, border_color: 'DDDDDD', background_color: 'DDDDDD' }
            )

  pdf.table(
            @goals.order(start_point: :desc, compulsory: :desc).map do |goal|
              [
                get_type(goal),
                goal.checkpoint.number,
                goal.checkpoint.grid_reference,
                goal.points_value
              ]
            end,
            width: 524, row_colors: ["FFFFFF", "F9F9F9"],
            cell_style: {padding: 2, border_color: 'DDDDDD', align: :center},
            column_widths: [131, 131, 131, 131],  position: :center
            )

  pdf.table(
            [["Finish (Scout Hut)", "-", "7275-8265", "-"]],
            width: 524, column_widths: [131, 131, 131, 131], position: :center,
            cell_style: { align: :center, border_color: 'DDDDDD'}
            )

  pdf.move_down 20

  pdf.text "Emergency Number: 01234 567890", align: :center, style: :bold,
  size: 14
  pdf.text "Phone in Number: 01234 567890", align: :center, style: :bold,
  size: 14

  pdf.move_down 20

  pdf.table(
            [["Points Calculation", ""]],
            width: 524, column_widths: [523, 1], position: :center,
            cell_style: { align: :center, font_style: :bold, border_color: 'DDDDDD', background_color: 'DDDDDD' }
            )
  pdf.table(
            [["Total visited checkpoints", ""]],
            width: 524, column_widths: [430, 94], position: :center,
            cell_style: { align: :left, border_color: 'DDDDDD' }
            )

  bonuses = [
              @challenge.bonus_one.to_s,
              @challenge.bonus_two.to_s,
              @challenge.bonus_three.to_s,
              @challenge.bonus_four.to_s,
              @challenge.bonus_five.to_s
            ]

  bonuses.each.with_index(1) do |bonus, idx| unless bonus.empty?
    bonus = eval(bonus)
    pdf.table(
              if bonus[:visit].is_a?(Array)  # Bonus based on specific checkpoints.
                [["Bonus #{idx} - visiting checkpoints #{bonus[:visit].to_sentence(last_word_connector: " and ")} = #{bonus[:value]} points", ""]]
              elsif bonus # Bonus based on total number of checkpoints.
                [["Bonus #{idx} - visiting #{bonus[:visit]} out of #{@goals.where(start_point: false).count} checkpoints = #{bonus[:value]} points", ""]]
              end,
              width: 524, column_widths: [430, 94], position: :center,
              cell_style: { border_color: 'DDDDDD' }
              )
    end
  end

  pdf.table([
              ["Phone call on time bonus (30 points, -1 for every minute early or late)", ""],
              ["Bonus for not being late back (30 points, -1 for every minute late up to -30)", ""]
            ],
            width: 524, column_widths: [430, 94], position: :center,
            cell_style: { align: :left, border_color: 'DDDDDD' }
            )

  pdf.table(
            [["Total Points", ""]],
            width: 524, column_widths: [430, 94], position: :center,
            cell_style: { align: :right, font_style: :bold,
            border_color: 'DDDDDD' }
            )
end
