### -----------------------------
### simon munzert
### workflow and good practice
### -----------------------------

## peparations -------------------

source("packages.r")


## Staying friendly on the web ------

# work with informative header fields
# don't bombard server
# respect robots.txt

# add header fields with rvest + httr
url <- "http://spiegel.de/schlagzeilen"
session <- html_session(url, add_headers(From = "my@email.com"))
headlines <- session %>% html_nodes(".schlagzeilen-headline") %>%  html_text()


# don't bombard server
for (i in 1:length(urls_list)) {
  if (!file.exists(paste0(folder, names[i]))) {
    download.file(urls_list[i], destfile = paste0(folder, names[i]))
    Sys.sleep(runif(1, 0, 1))
  }
}

# respect robots.txt
browseURL("https://www.google.com/robots.txt")
browseURL("http://www.nytimes.com/robots.txt")

library(robotstxt)
# more info see here: https://cran.r-project.org/web/packages/robotstxt/vignettes/using_robotstxt.html

paths_allowed("/", "http://google.com/", bot = "*")
paths_allowed("/", "https://facebook.com/", bot = "*")

paths_allowed("/imgres", "http://google.com/", bot = "*")
paths_allowed("/imgres", "http://google.com/", bot = "Twitterbot")


r_text <- get_robotstxt("https://www.google.com/")
r_parsed <- parse_robotstxt(r_text)
names(r_parsed)
table(r_parsed$permissions$useragent, r_parsed$permissions$field)




## Scheduling scraping tasks on Windows -------

browseURL("https://cran.r-project.org/web/packages/taskscheduleR/vignettes/taskscheduleR.html")


## Scheduling scraping tasks on a Mac ---------

browseURL("https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/ScheduledJobs.html")

# 1. create script (e.g., "spiegel_scraper.R")
# 2. add "#!/usr/local/bin/Rscript" to the top of the script
# 3. create plist file
# 4. load plist file into launchd scheduler and start it (via Terminal):
system("launchctl load ~/Library/LaunchAgents/spiegelheadlines.plist")
system("launchctl start spiegelheadlines")
system("launchctl list")

# 5. stop and unload it when desired
system("launchctl stop spiegelheadlines")
system("launchctl unload ~/Library/LaunchAgents/spiegelheadlines.plist")
