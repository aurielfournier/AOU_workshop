## Use Data Frames
## Use Factors
## Be Boss of your factors
## Keep your Data Frame Tidy
## Reshape your data


## GGPLOT SECTION OF AOU WORKSHOP

library(ggplot2)
library(ggthemes)
gdURL <- "http://tiny.cc/gapminder"
gDat <- read.delim(file = gdURL) 


p <- ggplot(gDat, aes(x = gdpPercap, y = lifeExp))

p + geom_point()

p + geom_point() + scale_x_log10()

p + geom_point(aes(color=continent))

ggplot(gDat, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() + scale_x_log10()

p <- ggplot(gDat, aes(x=gdpPercap, y=lifeExp))+scale_x_log10()

p + geom_point(alpha=(1/3), size=3)

p + geom_point() + geom_smooth()
# arguments se=F, lwd=number

p + geom_point() + geom_smooth(lwd = 3, se = FALSE, method = "lm")
# argument added = method 
# lm = linear model

p + aes(color=continent)+geom_point()+geom_smooth(lwd=3, se=F)
p + aes(color=continent)+geom_point()+geom_smooth(lwd=3, se=F,method="lm")

p + geom_point(alpha=(1/3), size=3)+facet_wrap(~continent)

p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent) +
  geom_smooth(lwd = 2, se = FALSE, method="lm")


# exercises:
#   
#   plot lifeExp against year
# make mini-plots, split out by continent
# add a fitted smooth and/or linear regression, w/ or w/o facetting
# other ideas?
# plot lifeExp against year


(y <- ggplot(gDat, aes(x = year, y = lifeExp)) + geom_point())

y + facet_wrap(~continent)

y + geom_smooth(se=FALSE, lwd=2)+geom_smooth(se=FALSE, method="lm",color="orange",lwd=2)

y + geom_smooth(se = FALSE, lwd = 2) +
  facet_wrap(~ continent)

y + facet_wrap(~ continent) + geom_line() # uh, no

y + facet_wrap(~ continent) + geom_line(aes(group = country)) +
  geom_smooth(se = FALSE, lwd = 2) 

ggplot(gDat[gDat$country== "Zimbabwe",],
       aes(x = year, y = lifeExp)) + geom_line() + geom_point()

jCountries <- c("Canada", "Rwanda", "Cambodia", "Mexico")
ggplot(subset(gDat, country %in% jCountries),
       aes(x = year, y = lifeExp, color = country)) + geom_line() + geom_point()

ggplot(subset(gDat, country %in% jCountries),
       aes(x = year, y = lifeExp, color = reorder(country, -1 * lifeExp, max))) +
  geom_line() + geom_point()

ggplot(gDat, aes(x = gdpPercap, y = lifeExp)) + scale_x_log10() + geom_bin2d()

## SAVING PLOTS ##

ggsave(y, filename="y.png", width=10, height=10)







## Kinds of Graphs ##

## Bar Graph

ggplot(gDat, aes(x=continent))+geom_bar()

b <- ggplot(gDat, aes(x=reorder(continent, continent, length))) + geom_bar()

b + coord_flip()

ggplot(gDat, aes(x=reorder(continent, continent, length))) + geom_bar(width=0.05)+coord_flip()



(jDat <- as.data.frame(with(gDat, table(continent, deparse.level = 2))))
ggplot(jDat, aes(x = continent)) + geom_bar()
ggplot(jDat, aes(x = continent, y = Freq)) + geom_bar(stat = "identity")

## Line Graph

p + geom_line()
p + geom_line(aes(group=country, color=country))+facet_wrap(~continent)



## Histogram

ggplot(gDat, aes(x=lifeExp))+geom_histogram()

## Scatter Plot

p + geom_point()

###################################
## THEMES ##

p <- ggplot(gDat, aes(x = gdpPercap, y = lifeExp))
p <- p + scale_x_log10()
p <- p + aes(color = continent) + geom_point() + geom_smooth(lwd = 3, se = FALSE)
p + ggtitle("Life Expectancy over time by continent")

p + theme_grey()
p + theme_bw()
p + theme_calc()
p + theme_economist()
p + theme_economist_white()
p + theme_few()
p + theme_gdocs()
p + theme_wsj()

###
# BUT YOU CAN DO IT YOURSELF
# OF COURSE


# these is where ggplot can become really really exhausting
# ALMOST anything you want to do, can be done

# things I know cannot be done

# you cannot have two y axis


p + theme(
  axis.text = element_text(size = 14),
  legend.key = element_rect(fill = "navy"),
  legend.background = element_rect(fill = "white"),
  legend.position = c(0.14, 0.80),
  panel.grid.major = element_line(colour = "grey40"),
  panel.grid.minor = element_blank(),
  panel.background = element_rect(fill = "navy")
)


p +   theme_bw() +
  theme(axis.text = element_text(size = 14),
        legend.key = element_rect(fill = "navy"),
        legend.background = element_rect(fill = "white"),
        legend.position = c(0.14, 0.80),
        panel.grid.major = element_line(colour = "grey40"),
        panel.grid.minor = element_blank()
  )