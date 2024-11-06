require 'colorize'

namespace :routes do
  desc 'Display rainbow-colored routes'
  task rainbow: :environment do
    ## This will make a big section for each route with each line a different color
    # routes = `rails routes --expanded`.lines 

    ## This will make each full route a different solid color 
    # simpleroutes = `rails routes`.lines
    # ## Define colors to cycle through
    # colors = [:red, :yellow, :green, :cyan, :blue, :magenta]
    # color_index = 0

    # routes.each do |route|
    #   puts route.colorize(colors[color_index])
    #   color_index = (color_index + 1) % colors.length
    # end

    # simpleroutes.each do |route2|
    #   puts route2.colorize(colors[color_index])
    #   color_index = (color_index + 1) % colors.length
    # end

    ## ANSI color codes for red and reset
    red_color = "\e[31m"
    yellow_color = "\e[33m"
    cyan_color = "\e[36m"
    blue_color = "\e[34m"
    purple_color = "\e[35m"
    reset_color = "\e[0m"

    # Color highlighted verbs, rainbow path and purple controller_action :)
    ## Fetch all routes
    routes = Rails.application.routes.routes.map do |route|
      verb = route.verb || ""
      path = route.path.spec.to_s
      controller_action = route.requirements.empty? ? "" : route.requirements.inspect

      ## Apply color to specific routes
      colored_verb = case verb
      when "GET"
        "#{red_color}#{verb}#{reset_color}"
      when "POST"
        "#{yellow_color}#{verb}#{reset_color}"
      when "PUT"
      "#{cyan_color}#{verb}#{reset_color}"
      when "DELETE"
      "#{purple_color}#{verb}#{reset_color}"
      else
        verb
      end

      def hex_to_ansi(hex_color)
        r = hex_color[0..1].to_i(16)
        g = hex_color[2..3].to_i(16)
        b = hex_color[4..5].to_i(16)
        "\e[38;2;#{r};#{g};#{b}m" # ANSI 24-bit color format
      end
    
      def rainbow_path(path)
        # Color codes for a rainbow gradient, edit for taste. :)
        colors = [
          "FF00FF", # Magenta
          "FF0000", # Red
          "FF7F00", # Orange
          "FFA500", # Orange Red
          "FFFF00", # Yellow
          "00FF7F", # Spring Green
          "00FF00", # Green
          "018a06", # Grass Green
          "008B8B", # Dark Cyan
          "00FFFF", # Cyan
          "02b6c9", # Slate Blue
          "035afc", # Sky Blue
          "0000FF", # Blue
          "0000ff", # Actual Blue
          "9803fc", # Purpley purple
          "4B0082", # Indigo
          "9400D3"  # Violet
        ]
        reset_color = "\e[0m"
      
        # Loop through each character and apply a color in sequence
        path.chars.each_with_index.map do |char, index|
          color = hex_to_ansi(colors[index % colors.length]) # Cycle through colors
          "#{color}#{char}#{reset_color}"
        end.join # Combine into a single string YAY!
      end
      
      # puts rainbow_path(path) ## - prints just the path part

      colored_controller_action = controller_action.empty? ? "" : "#{purple_color}#{controller_action}#{reset_color}"
      colored_prefix = route.path.spec.to_s.empty? ? "" : "#{blue_color}#{colored_prefix}#{reset_color}"

      # Combine colored verb with the rest of the route info
      "\n #{colored_verb.ljust(8)} #{rainbow_path(path).ljust(50)} \n #{colored_controller_action}"
    end

    # Print each route with colored verbs
    routes.each { |route| puts route }
  end
end

