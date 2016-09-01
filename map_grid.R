
library(ggmap)
library(dplyr)
library(gridExtra)

coord.data.frame = read.csv("Snap_Coordinates.csv")

coord.data.frame = coord.data.frame %>% 
  filter(Source != "MINDCONNECT") %>%
  rename(case = X, source = Source, lon = Longitude, lat = Latitude)

cases = unique(coord.data.frame$case)  

plots = lapply(cases, function(x) {
  current.data = coord.data.frame %>% filter(case == x)
  map.center = (current.data %>% filter(source == "STREET") %>% select(lon, lat))[1,]
  base.map = get_map(location = map.center, zoom = 12)
  plot = ggmap(base.map) +
    geom_point(data = current.data, aes(x = lon, y = lat, fill = source, alpha = 0.8)) +
    ggtitle(x)+
    theme(plot.margin = unit(c(0,0,0,0), "lines"), axis.title = element_blank(), 
          legend.position = "none")
})

do.call(grid.arrange, c(plots, nrow = ceiling(length(plots) / 3), ncol = 3, top = title))



