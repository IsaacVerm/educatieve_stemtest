### setup

## paths

setup_path <- file.path(root_path,"functions","general purpose","setup.RData")
vote_test_path <- file.path(root_path,"educatieve_stemtest","functions","vote_test.RData")
load_path <- file.path(root_path,"datasets","data","flemish_voting_test")
save_path <- file.path(root_path,"educatieve_stemtest","analysis","output","score_mechanism")

## setup environment

load(setup_path)

setup(used_packages = c("data.table","dplyr"))

### load

## files

load(file = file.path(load_path,"clean_statements_agreement.RData"))
load(file = file.path(load_path,"clean_statements_weight.RData"))
load(file = file.path(load_path,"clean_parties.RData"))
load(file = file.path(load_path,"clean_categories.RData"))

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

test_votes <- rep(1, times = 20)
test_weights <- rep(0, times = 8)

## simulate voting test

name_tests <- c("regionaal","brusselse","federaal","europees")

actual <- lapply(name_tests,
                 function(x) vote_test(x, test_votes, test_weights))

### analyse results

## combine actual and expected

expected$type <- "expected"
actual$type <- "actual"

difference <- rbindlist(list(actual, expected))

## calculate difference actual and expected by party

party_difference <- arrange(difference, party)
