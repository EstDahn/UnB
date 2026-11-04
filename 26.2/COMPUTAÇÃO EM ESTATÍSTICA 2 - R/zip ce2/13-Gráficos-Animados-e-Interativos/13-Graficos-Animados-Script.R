library(ggplot2)
library(gganimate)
library(gapminder)

# 1. Create a standard ggplot object
p <- ggplot(
  gapminder, 
  aes(x = gdpPercap, y = lifeExp, size = pop, colour = continent)
) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = c("Asia" = "#E41A1C", "Europe" = "#377EB8", 
                                 "Africa" = "#4DAF4A", "Americas" = "#984EA3", 
                                 "Oceania" = "#FF7F00")) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() + # Use a log scale for GDP per capita
  labs(
    title = 'Year: {frame_time}', 
    x = 'GDP per capita', 
    y = 'Life expectancy'
  )

# 2. Add the animation layer
anim <- p +
  transition_time(year) +
  ease_aes('linear')

# 3. Render the animation
# This will display the animation in your RStudio Plots pane.
# It may take a minute to render.
animate(anim)

# 4. Save the animation to a file
# Use anim_save() to save the last animation you rendered.
anim_save("gapminder_animation.gif")
