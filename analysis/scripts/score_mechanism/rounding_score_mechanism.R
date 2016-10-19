### setup

## paths

setup_path <- file.path(root_path,"functions","general purpose","setup.RData")
vote_test_path <- file.path(root_path,"educatieve_stemtest","functions","vote_test.RData")
load_path <- file.path(root_path,"datasets","data","flemish_voting_test")
save_path <- file.path(root_path,"educatieve_stemtest","analysis","output","score_mechanism")
load_path_extra <- save_path

## setup environment

load(setup_path)

setup()

### load

## files

load(file = file.path(load_path,"clean_statements_agreement.RData"))
load(file = file.path(load_path,"clean_statements_weight.RData"))
load(file = file.path(load_path_extra,"actual_all_agree_all_tests.RData"))
# load(file = file.path(load_path,"clean_parties.RData"))
# load(file = file.path(load_path,"clean_categories.RData"))
# load(file = file.path(load_path_extra,"nr_statements_by_test.RData"))
# load(file = file.path(load_path_extra,"themes_by_test.RData"))

## functions

load(vote_test_path)

### expected results

## make sure agreement and weights dataframes can be multiplied

statements_agreement$thesis <- NULL
statements_agreement$id <- NULL
statements_weight$id <- NULL

## function to create alternative versions statements_weight with different rounding digits

round_weights <- function(accuracy) statements_weight %>% group_by(test) %>% mutate_all(funs(round), digits = accuracy)

## only agree with the statements the parties chose to agree with

accuracy <- 0:7

expected <- lapply(accuracy, function(x) statements_agreement * round_weights(x))

## indication test got lost

expected <- lapply(expected, function(x) {
  
                  x$test <- statements_agreement$test
                  return(x) }
                  )

## function to calculate expected score

expected_score <- function(expected_df) expected_df %>% group_by(test) %>% summarise_all(funs(sum), na.rm = TRUE)

## calculate expected score

expected <- lapply(expected, expected_score)

## bind expected score dataframes together

# bind

expected <- rbindlist(expected, use.names = TRUE)

# add variable accuracy

expected$accuracy <- rep(accuracy, each = nrow(actual))

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

