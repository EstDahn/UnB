


gss_cat |> 
  filter(!is.na(tvhours)) |>
  group_by(relig) |> 
  summarise(tvhours = mean(tvhours, na.rm = T)) |> 
  ggplot(aes(tvhours, fct_reorder(relig,tvhours) ) ) +
#fct_reorder(relig,tvhours) - reordena os fatores da religião com base nas horas de tv
  geom_point() 

gss_cat |> 
  filter(!is.na(tvhours)) |>
  group_by(relig) |> 
  summarise(tvhours = mean(tvhours, na.rm = T)) |> 
  ggplot(aes(tvhours, fct_reorder(partyid,tvhours) ) ) +
  geom_point() + labs( y = "partido" )





gss_cat |> 
  ggplot(aes(marital)) + geom_bar()

gss_cat |> 
  ggplot(aes(fct_infreq(marital) ) ) + geom_bar()

gss_cat |> 
  ggplot(aes(fct_rev(fct_infreq(marital) ) ) ) + geom_bar()


