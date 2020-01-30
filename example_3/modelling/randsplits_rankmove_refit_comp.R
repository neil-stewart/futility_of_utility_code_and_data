rm(list = ls())

setwd('C:/Users/Tim/Dropbox/skewdist_projects/modelling')
require(tidyverse)

data = read_csv('cpt_alphas_halves_1a.csv')
eudata = read_csv('eu_alphas_halves_1a.csv')



# cptranks = apply(data, 1, rank)
# euranks = apply(eudata, 1, rank)
cptranks = data
cptranks[,] = t(apply(cptranks, 1, rank, ties.method = 'random'))
euranks = eudata
euranks[,] = t(apply(eudata, 1, rank, ties.method = 'random'))

startpoints = c(3,15,29,44,57)
# startpoints = c(1,15,29,44,59)
# startpoints = c(15,29,44)


allcombs = matrix(1:nrow(cptranks), 3, byrow = T)

cptrankmatch = matrix(NA, nrow(data)/3, length(startpoints))
refit_cptrankmatch = matrix(NA, nrow(data)/3, length(startpoints))
eurankmatch = matrix(NA, nrow(data)/3, length(startpoints))
refit_eurankmatch = matrix(NA, nrow(data)/3, length(startpoints))


cptranks = as.matrix(cptranks)
euranks = as.matrix(euranks)
for(i in 1:length(allcombs[1,])){
  for(k in 1:length(startpoints)){
    cptrankmatch[i,k] = mean(as.numeric(cptranks[allcombs[1,i], cptranks[allcombs[2,i],] == startpoints[k]]))
    refit_cptrankmatch[i,k] = mean(as.numeric(cptranks[allcombs[1,i], cptranks[allcombs[3,i],] == startpoints[k]]))
    eurankmatch[i,k] = mean(as.numeric(euranks[allcombs[1,i], euranks[allcombs[2,i],] == startpoints[k]]))
    refit_eurankmatch[i,k] = mean(as.numeric(euranks[allcombs[1,i], euranks[allcombs[3,i],] == startpoints[k]]))
  }
}

# cptrankchange = abs(cptrankmatch - rep(startpoints, each = nrow(data)/3))
# cptrankchange = as.data.frame(cptrankchange)
# colnames(cptrankchange) <- c('Rank_0', 'Rank_25', 'Rank_50', 'Rank_75', 'Rank_100')
# colnames(cptrankchange) <- c('Rank_0', 'Rank_25', 'Rank_50', 'Rank_75', 'Rank_100')
# p1 = ggplot(gather(cptrankchange)) + geom_histogram(aes(value/58, fill = key), position = 'dodge') + xlab('Absolute change in rank')

cptrankmatch = as.data.frame(cptrankmatch)
refit_cptrankmatch = as.data.frame(refit_cptrankmatch)
colnames(cptrankmatch) <- c('5 percentile', '25  percentile', '50 percentile', '75 percentile', '95 percentile')
colnames(refit_cptrankmatch) <- c('5 percentile', '25  percentile', '50 percentile', '75 percentile', '95 percentile')
# colnames(cptrankmatch) <- c('0 percentile', '25  percentile', '50 percentile', '75 percentile', '100 percentile')
# colnames(refit_cptrankmatch) <- c('0 percentile', '25  percentile', '50 percentile', '75 percentile', '100 percentile')
# colnames(cptrankmatch) <- c('25  percentile', '50 percentile', '75 percentile')
# colnames(refit_cptrankmatch) <- c('25  percentile', '50 percentile', '75 percentile')
# cpt_plotframe = gather(add_column(gather(cptrankmatch), refit_rank = gather(refit_cptrankmatch)$value))
cpt_plotframe = gather(add_column(gather(cptrankmatch), refit_rank = gather(refit_cptrankmatch)$value), 'rank_source', 'rankpos', c('value', 'refit_rank'))
# cpt_plotframe$key = factor(cpt_plotframe$key, levels = c('0 percentile', '25  percentile', '50 percentile', '75 percentile', '100 percentile'))
cpt_plotframe$key = factor(cpt_plotframe$key, levels = c('5 percentile', '25  percentile', '50 percentile', '75 percentile', '95 percentile'))

# p1 = ggplot(cpt_plotframe) + geom_histogram(aes(rankpos, fill = rank_source), position = 'dodge') + xlab('Distribution of paired rank') + facet_grid(~key) + scale_x_continuous(breaks=c(2,29,58), labels=c("0%", "50%", "100%"))
# p1 = p1 + theme(legend.title = element_blank()) + scale_fill_discrete(labels = c("Within Sample", "Out of Sample")) +  
#   theme_classic() +
#   theme(panel.background = element_rect(fill = NA), panel.border = element_rect(linetype = "solid", fill = NA), legend.title = element_blank()) + 
#   theme(axis.text.x = element_text(angle=45))


p1 = ggplot(cpt_plotframe) + geom_histogram(aes(rankpos, fill = rank_source), position = 'dodge') + xlab('Percentile') + ylab('Count') + facet_grid(~key) + scale_x_continuous(breaks=c(2,29,58), labels=c("0%", "50%", "100%")) + 
  theme(legend.title = element_blank()) + 
  theme_classic() +
  scale_fill_brewer(palette = "Dark2", labels = c("Within Half", "Second Half")) +
  # scale_fill_discrete(labels = c("Within Half", "Second Half")) +  
  theme(legend.title = element_blank()) +
  theme(strip.background = element_blank(),  
        strip.text=element_text(size=8)) +
  theme(axis.text.x = element_text(angle=45))
  

p1

ggsave("CPT_plot.pdf", plot = p1, width=6, height=4)

# %Neil's
# ggplot(booted.parameters, aes(x=choice.set, y=mean, ymin=lower, ymax=upper)) + geom_point() + geom_linerange() + facet_wrap(~parameter.label,                 scales="free_y", labeller=label_parsed) + theme_classic() +    
#   scale_color_brewer(palette = "Dark2") + labs(x="Choice Subset", y="Parameter   Value") + scale_x_discrete(labels=c("All Choices", "Scaled Down", "Scaled      Up")) + theme(strip.background = element_blank(),  
#                                                                                                                                                                               strip.text=element_text(size=20))


eurankmatch = as.data.frame(eurankmatch)
refit_eurankmatch = as.data.frame(refit_eurankmatch)
colnames(eurankmatch) <- c('5 percentile', '25  percentile', '50 percentile', '75 percentile', '95 percentile')
colnames(refit_eurankmatch) <- c('5 percentile', '25  percentile', '50 percentile', '75 percentile', '95 percentile')
# colnames(eurankmatch) <- c('0 percentile', '25  percentile', '50 percentile', '75 percentile', '100 percentile')
# colnames(refit_eurankmatch) <- c('0 percentile', '25  percentile', '50 percentile', '75 percentile', '100 percentile')
# colnames(eurankmatch) <- c('25  percentile', '50 percentile', '75 percentile')
# colnames(refit_eurankmatch) <- c('25  percentile', '50 percentile', '75 percentile')

eu_plotframe = gather(add_column(gather(eurankmatch), refit_rank = gather(refit_eurankmatch)$value), 'rank_source', 'rankpos', c('value', 'refit_rank'))
# eu_plotframe$key = factor(eu_plotframe$key, levels = c('0 percentile', '25  percentile', '50 percentile', '75 percentile', '100 percentile'))
eu_plotframe$key = factor(eu_plotframe$key, levels = c('5 percentile', '25  percentile', '50 percentile', '75 percentile', '95 percentile'))
# p2 = ggplot(eu_plotframe) + geom_histogram(aes(rankpos, fill = rank_source), position = 'dodge') + xlab('Distribution of paired rank') + facet_grid(~key) + scale_x_continuous(breaks=c(2,29,58), labels=c("0%", "50%", "100%"))
# p2 = p2 + theme(legend.title = element_blank()) + scale_fill_discrete(labels = c("Within Sample", "Out of Sample")) + 
#   theme_classic() +
#   theme(panel.background = element_rect(fill = NA), panel.border = element_rect(linetype = "solid", fill = NA), legend.title = element_blank()) + 
#   theme(axis.text.x = element_text(angle=45))
# 
# ggsave("EU_plot.pdf", plot = p2, height = 5 , width = 5 * 1.5)



p2 = ggplot(eu_plotframe) + geom_histogram(aes(rankpos, fill = rank_source), position = 'dodge') + xlab('Percentile') + ylab('Count') + facet_grid(~key) + scale_x_continuous(breaks=c(2,29,58), labels=c("0%", "50%", "100%")) + 
  theme(legend.title = element_blank()) + 
  theme_classic() +
  scale_fill_brewer(palette = "Dark2", labels = c("Within Half", "Second Half")) +
  # scale_fill_discrete(labels = c("Within Half", "Second Half")) +  
  theme(legend.title = element_blank()) +
  theme(strip.background = element_blank(),  
        strip.text=element_text(size=8)) +
  theme(axis.text.x = element_text(angle=45))

p2

ggsave("EU_plot.pdf", plot = p2, width=6, height=4)


# gridExtra::grid.arrange(p1, p2, p3, p4)

require(ggpubr)
# ggarrange(
#   p1, p2, p3, p4, labels = c("A", "B", "C", "D"),
#   common.legend = TRUE, legend = "bottom"
# )

ggarrange(
    p1, p2, labels = c("CPT", "EU"), hjust = c(-0.2, -0.9),
    nrow = 2,
    common.legend = TRUE, legend = "right"
  )




