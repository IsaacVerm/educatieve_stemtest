### setup

## paths

setup_path <- file.path(root_path,"functions","general purpose","setup.RData")
vote_test_path <- file.path(root_path,"educatieve_stemtest","functions","vote_test.RData")
load_path <- file.path(root_path,"datasets","data","flemish_voting_test")
save_path <- file.path(root_path,"educatieve_stemtest","analysis","output","score_mechanism")
load_path_extra <- save_path

## setup environment

load(setup_path)

setup(used_packages = c("data.table","dplyr","parallel","ggplot2","tidyr"))

### load

## files

load(file = file.path(load_path,"clean_statements_agreement.RData"))
load(file = file.path(load_path,"clean_statements_weight.RData"))
load(file = file.path(load_path,"clean_parties.RData"))
load(file = file.path(load_path,"clean_categories.RData"))
load(file = file.path(load_path_extra,"nr_statements_by_test.RData"))
load(file = file.path(load_path_extra,"themes_by_test.RData"))

## functions

load(vote_test_path)

### expected results

## make sure agreement and weights dataframes can be multiplied

statements_agreement$thesis <- NULL
statements_agreement$id <- NULL
statements_weight$id <- NULL

## only agree with the statements the parties chose to agree with

# agree

expected <- statements_agreement * statements_weight

# indication test got lost

expected$test <- statements_agreement$test

# expected score

expected <- expected %>% group_by(test) %>% summarise_all(funs(sum), na.rm = TRUE)

### actual results

## parameters

## set parameters

# votes

test_votes <- lapply(nr_statements$n, function(x) rep(1, times = x))

# weights

test_weights <- lapply(themes, function(x) try(sum(x)))

test_weights[["theme"]] <- NULL

test_weights <- lapply(test_weights, function(x) rep(0, times = x))

## simulate voting test

actual <- mapply(function(type,votes,weights) vote_test(type,votes,weights),
                 type = names(test_weights),
                 votes = test_votes,
                 weights = test_weights)

## get actual in the same format as expected

# put party name and score together

actual <- lapply(splitIndices(length(actual), length(actual)/2), function(x) actual[x])

actual <- lapply(actual, function(x) {
  
  score <- x[[1]]
  names(score) <- x[[2]]
  score <- as.data.frame(t(as.data.frame(score)))
  return(score) } )
  
# dataframe

actual <- rbindlist(actual, use.names = TRUE)

# add test name

actual$test <- names(test_weights)

### analyse results

## combine actual and expected

expected$type <- "expected"
actual$type <- "actual"

difference <- rbindlist(list(actual, expected), use.names = TRUE, fill = TRUE)

## calculate difference actual and expected by test

# calculate

difference_by_test <- difference %>% group_by(test) %>% summarise_at(vars(one_of(levels(parties$party))), diff)

# remove superfluous columns

col_keep <- names(difference_by_test)[!apply(difference_by_test, 2, function(x) sum(is.na(x))) == 4]
difference_by_test <- select(difference_by_test, one_of(col_keep))

## graph difference by test

# melt

molten_difference_by_test <- melt(difference_by_test)
names(molten_difference_by_test) <- c("test","party","difference")

# colours according to party

parties_palette <- paste0("#", parties$color[parties$party %in% unique(molten_difference_by_test$party)])

# graph

graph_difference_by_test <- ggplot(data = molten_difference_by_test,
                                   aes(x = test, y = difference, group = party, colour = party)) + 
                            geom_line() +
                            scale_colour_manual(values = parties_palette) +
                            labs(y = "verschil tussen verwachte en echte score") + 
                            theme(legend.title=element_blank())

plot(graph_difference_by_test)

### save

save(actual, file = file.path(save_path,"actual_all_agree_all_tests.RData"))
ggsave(graph_difference_by_test, file = file.path(save_path,"difference_by_test.png"))
