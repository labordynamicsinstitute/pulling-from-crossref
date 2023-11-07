## ----setup, include=FALSE-----------------------------------------------------


## ----config_libs,include=FALSE,message=FALSE----------------------------------
source(file.path(rprojroot::find_root(rprojroot::has_file("pathconfig.R")),"pathconfig.R"),echo=TRUE)
source(file.path(basepath,"global-libraries.R"),echo=TRUE)
source(file.path(basepath,"config.R"),echo=TRUE)





## ----issn---------------------------------------------------------------------
# Each journal has a ISSN
if (!file.exists(issns.file)) {
issns <- data.frame(matrix(ncol=3,nrow=5))
names(issns) <- c("journal","issn","lastdate")
tmp.date <- c("2016-01")
issns[1,] <- c("American Economic Journal: Applied Economics","1945-7790",tmp.date)
issns[2,] <- c("American Economic Journal: Economic Policy","1945-774X",tmp.date)
issns[3,] <- c("American Economic Journal: Macroeconomics", "1945-7715",tmp.date)
issns[4,] <- c("American Economic Journal: Microeconomics", "1945-7685",tmp.date)
issns[5,] <- c("The American Economic Review","1944-7981",tmp.date)
issns[6,] <- c("The American Economic Review","0002-8282",tmp.date)  # print ISSN is needed!

saveRDS(issns, file= issns.file)
}

issns <- readRDS(file = issns.file)



## ----read_AEA-----------------------------------------------------------------
# Run this only once per session
#if ( file.exists(issns.file) & !file.exists(new.file.Rds)) {
if ( file.exists(issns.file) ) {
	new.df <- NA
	for ( x in 1:4 ) {
		new <- cr_journals(issn=issns[x,"issn"], works=TRUE,
				   filter=c(from_pub_date=issns[x,"lastdate"]),
				   select=c("DOI","title","published-print","volume","issue","container-title","author"),
				   .progress="text",
				   cursor = "*")
		if ( x == 1 ) {
      		new.df <- as.data.frame(new$data)
      		new.df$issn = issns[x,"issn"]
    	} else {
    	    tmp.df <- as.data.frame(new$data)
    	    tmp.df$issn = issns[x,"issn"]
      		new.df <- bind_rows(new.df,tmp.df)
      		rm(tmp.df)
    	}
	}
	saveRDS(new.df, file= new.file.Rds)
	rm(new)
}

