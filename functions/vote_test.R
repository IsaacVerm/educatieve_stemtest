### function

vote_test <- function(test_type, votes) {
  
              # setup selenium
  
              library(RSelenium)
  
              RSelenium::startServer(javaargs = c("-Dwebdriver.gecko.driver=\"C:/Users/Isaac/Documents/geckodriver.exe\"")) 
  
              driver <- remoteDriver(extraCapabilities = list(marionette = TRUE))
  
              driver$open()
  
              # go to voting test
  
              driver$navigate(paste0("http://www.educatievestemtest.be/", test_type)) 
              
              # vote
              
              lapply(votes, function(x) {
                
                Sys.sleep(2)
                
                choice_xpath <- "//div[@class='statement'][not(contains(@style,'display: none; left: -880px;') or contains(@style,'left: -880px; display: none;'))]//div[@class='button button-1']"
                
                choice <- driver$findElement(using = "xpath",
                                             choice_xpath)
                
                choice$clickElement() }
                )
              
              }
  
  
### test

votes <- sample(1:2, 35, replace = TRUE)

vote_test("regionaal", votes = votes)
  