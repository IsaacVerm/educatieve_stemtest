### setup

## paths

setup_path <- file.path(root_path,"functions","general purpose","setup.RData")
vote_test_path <- file.path(root_path,"educatieve_stemtest","functions","vote_test.RData")
load_path <- file.path(root_path,"datasets","data","flemish_voting_test")
save_path <- file.path(root_path,"educatieve_stemtest","analysis","output")

## setup environment

load(setup_path)

setup()

### load

## files

load(file = file.path(load_path,"raw_statements_agreement.RData"))

## functions

load(vote_test_path)

### influence weights on score

## set parameters

cdv_votes <- filter(statements_agreement, test == "federaal")[["CD&V"]]

test_weights <- lapply(1:11, function(x) c(0,50,100))

## simulate voting test

test_1 <- vote_test(test_type = "federaal", votes = cdv_votes, weights = rep(0, times = 11))
test_2 <- vote_test(test_type = "federaal", votes = cdv_votes, weights = rep(100, times = 11))

rbind(test_1, test_2)

