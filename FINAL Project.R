# PSCI 7381: Social Networks, Spring 2021
# Prof. Lauren Santoro
# FINAL PAPER
# Federico Ferrero

# clear your memory
rm(list=ls())

# set your working directory path
setwd("C:/Users/feder/Desktop")

# importing data into R
library(statnet)
library(UserNetR)
library(igraph)
library(sna)


edges<- read.csv("https://raw.githubusercontent.com/federico-jf/Social-Network-Analysis-PSCI-7381/main/final_edges_2.csv", header=T, as.is=T)
nodes<- read.csv("https://raw.githubusercontent.com/federico-jf/Social-Network-Analysis-PSCI-7381/main/final_nodes_2.csv", header=T, as.is=T)


networkasigraph <- graph_from_data_frame(d=edges, vertices=nodes, directed = TRUE)
networkasigraph
class(networkasigraph)# verify the class of object: it's an object

# from igraph to statnet and ask for summary
library(intergraph)
networkasnet <- asNetwork(networkasigraph)
class(networkasnet)# verify the class of object: it's a network object
summary(networkasnet)

# size of network
network.size(networkasnet)

# number of components
components(networkasigraph)

# degree centrality
summary(degree(networkasigraph, mode = "in"))

summary(degree(networkasigraph, mode = "out"))

summary(degree(networkasigraph, mode = "all"))

mean(nodes$number_tweets)

# betweenness
betweenness(networkasigraph)
summary(betweenness(networkasigraph))
table(betweenness(networkasigraph))

# statistics for other variables
summary(nodes$user_followed_count)
summary(nodes$user_followers_count)
summary(nodes$number_tweets)
summary(nodes$Profile)

#degree distribution
degreedist(networkasnet, gmode="digraph")

# plotting the network
# removing the loops
networkasigraph <- simplify(networkasigraph, remove.multiple = F, remove.loops = T)
summary(networkasigraph)

# defining labels according degrees
node_label <- V(networkasigraph)$node_label <- unname(ifelse(degree(networkasigraph)[V(networkasigraph)] > 7,
                                                             names(V(networkasigraph)), ""))

# defining color edges depending on type of link (reply = blue / retweet = hotpink)
edge_color <-E(networkasigraph)$color <- ifelse(E(networkasigraph)$type_link=="reply",'blue','hotpink')

# changing node size using centrality measures (in)
in_degree <- degree(networkasigraph, mode="in") # all, in, out
in_degree
V(networkasigraph)$size <- in_degree*1.41

# giving colors to nodes according main profiles
V(networkasigraph)[V(networkasigraph)$Profile == "Politician"]$color <- "brown2"
V(networkasigraph)[V(networkasigraph)$Profile == "Professor/Researcher"]$color <- "cadetblue"
V(networkasigraph)[V(networkasigraph)$Profile == "Media organization"]$color <- "goldenrod2"
V(networkasigraph)[V(networkasigraph)$Profile == "Union Leader"]$color <- "lightpink"
V(networkasigraph)[V(networkasigraph)$Profile == "Other"]$color <- "yellowgreen"

# plot
plot(networkasigraph, layout=layout_nicely,
     edge.arrow.size=.19,
     vertex.label.color="black",
     vertex.label = node_label,
     vertex.label = node_label,
     color.edge= edge_color,
     main="First retweets, replies, and mentions in #AlevelResults discussion")

# adding legendas
legend(x=-1.3, y=-1.1,legend=c("Politician","Professor/Researcher", "Media Organization",
                               "Union Leader", "Other Citizen"), pch=21,
       col= c("brown2","cadetblue","goldenrod2","lightpink","yellowgreen"),
       pt.bg= c("brown2","cadetblue","goldenrod2","lightpink","yellowgreen"),text.font= 8,
       pt.cex=2, cex=.9, bty="n", ncol=1)

legend(x=0.4, y=-1.2, legend=c("Reply/Mentions", "Retweet"),
       col=c("blue","hotpink"), lty=1, cex=0.9, box.lty=0, text.font= 8)

# ploting "egonet" of the participant with higher betweeness centrality

edges_ego<- read.csv("https://raw.githubusercontent.com/federico-jf/Social-Network-Analysis-PSCI-7381/main/edges_ego_net.csv", header=T, as.is=T)
nodes_ego<- read.csv("https://raw.githubusercontent.com/federico-jf/Social-Network-Analysis-PSCI-7381/main/nodes_ego_net.csv", header=T, as.is=T)


networkasigraph2 <- graph_from_data_frame(d=edges_ego, vertices=nodes_ego, directed = TRUE)
networkasigraph2
class(networkasigraph2)# verify the class of object: it's an object

# from igraph to statnet and ask for summary
library(intergraph)
networkasnet2 <- asNetwork(networkasigraph2)
class(networkasnet2)# verify the class of object: it's a network object
summary(networkasnet2)

# number of components
components(networkasigraph2)

# plotting the egonet of the participant with higest betweeness centrality
# defining color edges depending on type of link (reply = blue / retweet = hotpink)
edge_color <-E(networkasigraph2)$color <- ifelse(E(networkasigraph2)$type_link=="reply",'blue','hotpink')

# changing node size using centrality measures (in)
in_degree <- degree(networkasigraph2, mode="in") # all, in, out
in_degree
V(networkasigraph2)$size <- in_degree*5.1


# giving colors to nodes according main profiles
V(networkasigraph2)[V(networkasigraph2)$Profile == "Politician"]$color <- "brown2"
V(networkasigraph2)[V(networkasigraph2)$Profile == "Professor/Researcher"]$color <- "cadetblue"
V(networkasigraph2)[V(networkasigraph2)$Profile == "Media organization"]$color <- "goldenrod2"
V(networkasigraph2)[V(networkasigraph2)$Profile == "Union Leader"]$color <- "lightpink"
V(networkasigraph2)[V(networkasigraph2)$Profile == "Other"]$color <- "yellowgreen"
V(networkasigraph2)[V(networkasigraph2)$Profile == "Writer"]$color <- "yellow"
V(networkasigraph2)[V(networkasigraph2)$Profile == "Activist"]$color <- "magenta"

# plot
plot(networkasigraph2, layout=layout_nicely,
     edge.arrow.size=.10,
     vertex.label.color="black",
     color.edge= edge_color,
     main="Main Broker in #AlevelResults discussion")

# adding legendas
legend(x=-3.3, y=-1.1,legend=c("Politician","Professor/Researcher", "Media Organization",
                               "Union Leader", "Other Citizen", "Writer", "Activist"), pch=21,
       col= c("brown2","cadetblue","goldenrod2","lightpink","yellowgreen", "yellow", "magenta"),
       pt.bg= c("brown2","cadetblue","goldenrod2","lightpink","yellowgreen", "yellow", "magenta"),text.font= 8,
       pt.cex=2, cex=.8, bty="n", ncol=1)

legend(x=0.4, y=-1.2, legend=c("Reply/Mentions", "Retweet"),
       col=c("blue","hotpink"), lty=1, cex=0.8, box.lty=0, text.font= 8)

dev.off()

# ERGM model
library(ergm)
set.seed(510) # set a random seed so we can produce exactly the same results

# null model
nullmodel <- ergm(networkasnet~edges, control=control.ergm(MCMC.samplesize=500,MCMC.burnin=1000,
                                                           MCMLE.maxit=10),verbose=TRUE)
summary(nullmodel)
# final model

finalmodel <- ergm(networkasnet~edges+nodecov('user_followers_count')+
                       nodecov('user_followed_count')+
                       nodecov('number_tweets')+
                       nodematch('Profile'), control=control.ergm(MCMC.samplesize=500,MCMC.burnin=1000,
                                                                  MCMLE.maxit=10),verbose=TRUE)
summary(finalmodel)
# interpretation on "Number of tweets" coefficient
exp(0.2004)
# 1.221891
# As we can see, number of tweets published is a positive significant predictor of linkage in #AlevelResults network.
# Holding all other effects constant, considering specifically the number of tweets
# posted by each user, the relative likelihood of observing a link in the network is 1.22.

# interpretation of "Profile" coefficient
# edges captures the number of edges in the model
# a homophily term that captures the effect of two actors in the network
# having the same Twitter account profile
# nodematch("Profile")= counts the number of cases in which any two nodes sharing an edge
# have that same qualitative attribute (in this case the profile)

# log odds of a tie across profiles in the Twitter discussion is -6.204 (edges coefficient)
# Take the inverse logistic transformation
# logit^{-1}(-6.204) = I/(1 + exp(6.204)) = 0.0020 = probability of a tie across profiles
library(gtools)
a <- inv.logit(-6.204)
a
# what about odds in the same profile?
# compute the log odds of such a tie = -6.204 - (-1.078) = -5.126
# take the same inverse logistic transformation
# exp(-5.126)/(1 + exp(-5.126)) = 0.0059 = probability of a tie within profiles
b<- inv.logit(-5.126)
b
b-a

# The probability of forming a within-profile edge is 0.0038 higher than forming an across-profile edge

# mybluekite and her probabilities to connect with active and non-active users
p_edg <-coef(finalmodel) [1]
p_num_tweets<-coef(finalmodel) [4]
# mybluekite and her probabilities to connect with active users like ChristineJameis (posted 8 tweets)

r<- plogis(p_edg + 1*p_num_tweets + 8*p_num_tweets)
# mybluekite and her probabilities to connect with non-active users like Nafiisaa (posted only 1 tweet)

t<- plogis(p_edg + 1*p_num_tweets + 1*p_num_tweets)
r-t

# print in a table finalmodel outputs
library('stargazer')
stargazer(finalmodel, title = "Testing ERGM model", out="table_ergm_final.txt")

# extract number of observations of finalmodel
nobs(finalmodel)

# analyzing the model fit
gof <- gof(finalmodel)

# execute goodness of fit function and creates a new object, gof
# produces some gof plots from the object
par(mfrow=c(2,2))
plot(gof)

# see gof meassures
gof
# small p-values indicate problems
# b/c they indicate that there is a statistically significant difference
# between observed value of the statistic and the simulated values
# whereas good fit would have it that these values should be similar.
