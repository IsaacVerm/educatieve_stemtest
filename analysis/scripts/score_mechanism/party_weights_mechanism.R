### setup

## paths

setup_path <- file.path(root_path,"functions","general purpose","setup.RData")
vote_test_path <- file.path(root_path,"educatieve_stemtest","functions","vote_test.RData")
load_path <- file.path(root_path,"datasets","data","flemish_voting_test")
save_path <- file.path(root_path,"educatieve_stemtest","analysis","output")

## setup environment

load(setup_path)

setup(used_packages = c("data.table","dplyr"))

### load

## files

load(file = file.path(load_path,"clean_statements_agreement.RData"))
load(file = file.path(load_path,"clean_statements_weight.RData"))
load(file = file.path(load_path,"clean_parties.RData"))

## functions

load(vote_test_path)

### expected results

## select only parties and only 1 test

statements_agreement <- select(filter(statements_agreement, test == "brusselse"),
                                      one_of(as.character(parties$party)))

statements_weight <- select(filter(statements_weight, test == "brusselse"),
                            one_of(as.character(parties$party)))

## only agree with the statements the parties chose to agree with

expected <- statements_agreement * statements_weight

expected <- as.data.frame(apply(expected, 2, sum))

expected$party <- rownames(expected)
rownames(expected) <- NULL
names(expected) <- c("party","score")

### actual results

## parameters

## set parameters

test_votes <- rep(1, times = 20)
test_weights <- rep(0, times = 8)

## simulate voting test

actual <- vote_test("brusselse", test_votes, test_weights)

### analyse results

## combine actual and expected

expected$type <- "expected"
actual$type <- "actual"

difference <- rbindlist(list(actual, expected))

## calculate difference actual and expected by party

party_difference <- arrange(difference, party)
