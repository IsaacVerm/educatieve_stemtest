# setup selenium

library(RSelenium)

RSelenium::startServer(javaargs = c("-Dwebdriver.gecko.driver=\"C:/Users/Isaac/Documents/geckodriver.exe\""))

driver <- remoteDriver(extraCapabilities = list(marionette = TRUE))

driver$open()

### function

vote_test <- function(test_type, votes, weights) {
  
              # go to voting test

              driver$navigate(paste0("http://www.educatievestemtest.be/", test_type))

              # vote

              lapply(votes, function(x) {
                
                Sys.sleep(2)

                xpath_not_visible_1 <- "'display: none; left: -880px;'"
                xpath_not_visible_2 <- "'left: -880px; display: none;'"

                choice_xpath <- paste0("//div[@class='statement'][not(contains(@style,",
                                       xpath_not_visible_1,
                                       ") or contains(@style,",
                                       xpath_not_visible_2,
                                       "))]//div[@class='button button-",
                                       x,
                                       "']")

                choice <- driver$findElement(using = "xpath",
                                             choice_xpath)

                choice$clickElement() }
                )

              # choose weights
              
              Sys.sleep(2)
              
              slider_nrs <- 1:length(weights)
              
              mapply(function(slider_nr, weight) {
                
                slider_xpath <- paste0("(//div[@class='handle'])[",
                                       slider_nr,
                                       "]")
              
                slider <- driver$findElement(using = "xpath",
                                             slider_xpath)
              
                slider$setElementAttribute("style", paste0("left: ",weight,"%;")) },
                slider_nr = slider_nrs,
                weight = weights)
              
              # submit
              
              submit_xpath <- "//span[@class='big-grey next-button']"
              
              submit <- driver$findElement(using = "xpath",
                                           submit_xpath)
              
              submit$clickElement()
              
              
              # get results
              
              Sys.sleep(2)
              
              results_xpath <- "//div[@class='bar']"
              
              results <- driver$findElements(using = "xpath",
                                             results_xpath)
              
              results <- lapply(results, function(x) x$getElementAttribute("style"))
              
              parties_xpath <- "//div[@class='graphs']/div"
              
              parties <- driver$findElements(using = "xpath",
                                             parties_xpath)
              
              parties <- lapply(parties, function(x) x$getElementAttribute("class"))
              
              result <- list(results, parties)
              
              return(result)

              }
  
  
### test

random_votes <- sample(0:2, 35, replace = TRUE)

random_weights <- seq(from = 0, to = 100, length.out = 11)

result_test <- vote_test("federaal", votes = random_votes, weights = random_weights)




