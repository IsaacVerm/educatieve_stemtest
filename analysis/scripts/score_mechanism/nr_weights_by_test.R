### setup

## paths

setup_path <- file.path(root_path,"functions","general purpose","setup.RData")
load_path <- file.path(root_path,"datasets","data","flemish_voting_test")
save_path <- file.path(root_path,"educatieve_stemtest","analysis","output","score_mechanism")

## setup environment

load(setup_path)

setup()

### load

## files

load(file = file.path(load_path,"clean_categories.RData"))

### number of statements by test

nr_statements <- categories %>% group_by(test) %>% summarise(n = n())

### number of weights by test

## simplify by taking template statement by test

# indices template statements

template_ind <- c(1, head(cumsum(nr_statements$n), -1) + 1)

# select template statements
  
templates <-  categories[template_ind, ]

# remove test as variable

templates$test <- NULL

## find themes by test

themes <- as.data.frame(apply(templates, 1, function(x) is.na(x)))

## correct names

themes$theme <- rownames(themes)
rownames(themes) <- NULL

names(themes) <- c(unique(categories$test),"theme")

### save

save(themes, file = file.path(save_path,"themes_by_test.RData"))
save(nr_statements, file = file.path(save_path,"nr_statements_by_test.RData"))
