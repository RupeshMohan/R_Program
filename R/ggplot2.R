require(ggplot2) ## Load Libarary

data("mpg")

df<-mpg

ggplot(data=df)+geom_point(mapping = aes(x=displ,y=hwy,color=class)) # color scater polts

ggplot(data=df)+geom_point(mapping = aes(x=displ,y=hwy,size=class,color=class)) # differentiate based on class size

ggplot(data=df)+geom_point(mapping = aes(x=displ,y=hwy,alpha=class))

ggplot(data=df)+geom_point(mapping = aes(x=displ,y=hwy,shape=class))

ggplot(data=df)+geom_point(mapping = aes(x=displ,y=hwy))+facet_wrap(~class,ncol=7)

ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ,y=hwy))+
  geom_smooth(mapping = aes(x = displ, y = hwy))

## BAR PLOT 

ggplot(data=df)+stat_count(mapping = aes(x=df$class))

