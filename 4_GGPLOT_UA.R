## good resources for learning about ggplot
# https://github.com/jennybc/ggplot2-tutorial
# http://www.amazon.com/dp/0387981403/ref=cm_sw_su_dp?tag=ggplot2-20
# http://inundata.org/2013/04/10/a-quick-introduction-to-ggplot2/

## good resources for learning about R
# R programming course (FREE from John Hopkins) https://www.coursera.org/course/rprog
# software carpentry - https://swcarpentry.github.io/r-novice-inflammation/
# https://stat545-ubc.github.io/

# Rstudio - http://www.rstudio.com/

## - load these packages use the install.packages("package name here") if they are not installed

library(ggplot2)
library(ggthemes)
library(RColorBrewer)

# the data we are using today is called the gapminder dataset
gdURL <- "http://tiny.cc/gapminder"
gDat <- read.delim(file = gdURL) 

head(gDat)

# to begin every plot in ggplot we start with the ggplot() command
# often this is where you give it your data and start things off, but it is never where you end

p <- ggplot(gDat, aes(x = gdpPercap, y = lifeExp))
## no layers in plot
p
## what we have done so far is told ggplot what data we want to use and what axis we want it on, but we haven't told it what kind of graph we want. 

# we can take our graphing object p and add the kind of graph we want, (geom) in this case we want the data represented as points 
p + geom_point() # to keep the geom_point as part of p we need to assign it all back to me

p = p + geom_point() # when it is assigned to p you then have to call 'p' to get the graph to print

p # see now we have a graph

# log transform the x axis
p = p +  scale_x_log10()

# color the points by the continent they come from
p = p + aes(color=continent) 

# the data and aesthetic inputs do not have to be in the ggplot function. If you put them there you will use them for all elements. Sometimes though you want to call from differnet datasets into different elemetns, in that case you put the data and aesthetics in that particular function (one for dots, one for lines)

ggplot() +
  geom_point(gDat, aes(x = gdpPercap, y = lifeExp, color = continent)) + 
  scale_x_log10()

###
p <- ggplot(gDat, aes(x=gdpPercap, y=lifeExp))+scale_x_log10()# here we are starting a new with a new R object called p, this is unrelated to the p above. 

p # again, we haven't used a geom_ layer yet so this doesn't actually show us anything

#alpha gives you transparent points
p = p + geom_point(alpha=(1/3), size=3)
# alpha is for transparency in points
# size is for the size of the points

p +  geom_smooth()


p + geom_point() + geom_smooth(lwd = 1, se = TRUE, method = "lm")
# argument added = method 
# lm = linear model
# lwd = line width
# se = either true or false for the standard error

# you can always add onto the aesthetics later by adding an additional aes command. 

# smooth spline line
p + aes(color=continent)+geom_smooth(lwd=3, se=F)

# linear model line
p + aes(color=continent)+geom_smooth(lwd=3, se=F,method="lm")

# ok but that is ALOT of lines on the same graph, and is super messy. Maybe good for a first glance, but not beyond that
# thsi is where facet wrap comes into play

p + aes(color=continent)+facet_wrap(~continent)


p + geom_point(alpha = (1/3), size = 3, aes(color=continent)) + facet_wrap(~ continent) +
  geom_smooth(lwd = 1, se = FALSE, method="lm")

# exercises:

# plot lifeExp against year

# make mini-plots, split out by continent

# add a fitted smooth and/or linear regression, w/ or w/o facetting


(y <- ggplot(gDat, aes(x = year, y = lifeExp)) + geom_point())

y + facet_wrap(~continent)

y + geom_smooth(se=FALSE, lwd=2)+geom_smooth(se=FALSE, method="lm",color="orange",lwd=2)

y + geom_smooth(se = FALSE, lwd = 2) +
  facet_wrap(~ continent)

# ok what if we want to draw this with lines connecting the life expectancy of each country? 
y + facet_wrap(~ continent) + geom_line() # uh, no

# need to give the aesthetic group = country otherwise it runs one line through all the points. 
y + facet_wrap(~ continent) + geom_line(aes(group = country)) +
  geom_smooth(se = FALSE, lwd = 2) 

# we can also subset data to look at specific parts of it 
# there are several ways to subset in R, this is the way I prefer

ggplot(gDat[gDat$country== "Zimbabwe",],
       aes(x = year, y = lifeExp)) + geom_line() + geom_point()

# to look at multiple countries there are several ways you can do this
# the first is similar to above, you just add on additional countries using " | " which means 'or" 
ggplot(gDat[gDat$country== "Zimbabwe"|gDat$country=="Canada",],
       aes(x = year, y = lifeExp, group=country)) + geom_line() + geom_point()

# there is a simpler way though

# these are the countries we want
jCountries <- c("Canada", "Rwanda", "Cambodia", "Mexico")

# and now within the subset function we are saying take gDat, and give us the countries from gDat that are in jCountries using the " %in% operator
ggplot(subset(gDat, country %in% jCountries),
       aes(x = year, y = lifeExp, color = country)) + geom_line() + geom_point()

#what if we want the order of the colors and legend to match the order of the lines?
# we can use the reorder function as part of the color argument
ggplot(subset(gDat, country %in% jCountries),
       aes(x = year, y = lifeExp, color = reorder(country, -1 * lifeExp, max))) +
  geom_line() + geom_point()



## SAVING PLOTS ##

ggsave(y, filename="y.png", width=10, height=10)

png(filename="plot.png")
# put plot here
dev.off()

## Kinds of Graphs ##

## so there are different geoms for different kinds of graphs, we'll cover some of the basics here

## Bar Graph

ggplot(gDat, aes(x=continent))+geom_bar()

b <- ggplot(gDat, aes(x=reorder(continent, continent, length))) + geom_bar()

b + coord_flip()

#you can make the bars bigger or smaller

ggplot(gDat, aes(x=reorder(continent, continent, length))) + geom_bar(width=0.05)+coord_flip()


 # bar plots with already given y values
(jDat <- as.data.frame(with(gDat, table(continent, deparse.level = 2))))
ggplot(jDat, aes(x = continent)) + geom_bar() # we switched data to jDat here~
# since the jDat data only has one line for each continent all the bars are the same height, but we can tell it to make the height related to frequency by giving it a y variable AND by setting stat = "identity' within geom_bar
ggplot(jDat, aes(x = continent, y = Freq)) + geom_bar(stat = "identity")

## Line Graph

p + geom_line()
p + geom_line(aes(group=country, color=country))+facet_wrap(~continent)

## Histogram

ggplot(gDat, aes(x=lifeExp))+geom_histogram()

## Scatter Plot

p + geom_point()

## box plots

p + geom_boxplot()

###################################
## THEMES ##

p <- ggplot(gDat, aes(x = gdpPercap, y = lifeExp))+geom_point()

# how to label axis
p + ggtitle("Life Expectancy over time by continent") + xlab("text here") + ylab("text here")

# these are some of the themes offered by ggthemes, these are either take them or leave them, some are quite nice
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
    # you cannot have two different y axis

?theme # lots of good detail here 

p + theme(
  axis.text = element_text(size = 35),
  axis.title=element_text(size=50, color="red"),
  legend.key = element_rect(fill = "navy"),
  legend.background = element_rect(fill = "white"),
  legend.position = c(0.14, 0.80),
  panel.grid.major = element_line(colour = "grey40"),
  panel.grid.minor = element_blank(), # element_blank() is when you don't want something, in this ase the minor grid lines, also works for text, titles, etc
  panel.background = element_rect(fill = "navy")
)


p  +
  theme(axis.text = element_text(size = 14),
        legend.key = element_rect(fill = "navy"),
        legend.background = element_rect(fill = "white"),
        legend.position = c(0.14, 0.80),
        panel.grid.major = element_line(colour = "grey40"),
        panel.grid.minor = element_blank()
  )+   theme_bw()


# Legends

p  +
  theme(axis.text = element_text(size = 14),
        legend.key = element_rect(fill = "navy"),
        legend.background = element_rect(fill = "red"),
        legend.position = "top",
        panel.grid.major = element_line(colour = "grey40"),
        panel.grid.minor = element_blank()
  )



# Colors

#http://colorbrewer2.org/

# so this works now on my desktop but isn't working on my laptop, I'm not sure why. But this should give you the color blind friendly color schemes to choose from. 
display.brewer.all(n=NULL, type="all", select=NULL, exact.n=TRUE,colorblindFriendly=TRUE)
  
# here you pick one of the names from the above display and tell it how many colors you need and save it to an object
mypalette<-brewer.pal(5,"Greens")

ggplot(gDat, aes(x=continent, fill=continent)) + geom_bar()+ scale_fill_manual(values=mypalette)

mypalette<-brewer.pal(5,"Set2")

ggplot(gDat, aes(x=continent, fill=continent)) + geom_bar()+ scale_fill_manual(values=mypalette)

# any questions shoot them my way - aurielfournier@gmail.com

