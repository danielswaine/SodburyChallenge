prawn_document(page_size: "A4") do |pdf|

  # Styles
  pdf.line_width 10
  pdf.stroke_color "473061"

  @challenges.each_with_index do |challenge, idx|

    pdf.start_new_page unless idx == 0
    
    challenge.teams.each_with_index do |team, idx1|

      pdf.start_new_page unless idx1 == 0

      # Page Border
      pdf.bounding_box([0,770], width: 515, height: 770) do
      pdf.stroke_bounds

          pdf.move_down 20

          pdf.image "#{Rails.root}/app/assets/images/scouts_be_prepared.png", scale: 0.4, position: :center

          pdf.move_down 70

          pdf.text "This certificate is awarded to", align: :center, size: 20
          pdf.move_down 30

          pdf.text "#{team.name}", align: :center, style: :bold, size: 24

          pdf.move_down 30

          pdf.text "for completing the Sodbury Challenge #{team.challenge.date.strftime('%Y')}", align: :center, size: 20

          pdf.move_down 20

          pdf.image "#{Rails.root}/app/assets/images/scouts_logo.png", scale: 0.1, position: :center

          pdf.image "#{Rails.root}/app/assets/images/signature.jpg", position: :right, at: [400, 90], scale: 0.6

          pdf.bounding_box([15, 30], :width => 300, :height => 20) do
            pdf.text team.challenge.date.to_formatted_s(:long_ordinal), size: 14
          end

          pdf.bounding_box([100, 50], :width => 400, :height => 20) do
            pdf.text "Daniel Swaine", size: 14, align: :right
          end

          pdf.bounding_box([100, 30], :width => 400, :height => 20) do
            pdf.text "On behalf of 1st Chipping Sodbury Scout Group", size: 14, align: :right
          end
      end

    end
  end
end
