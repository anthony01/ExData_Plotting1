library(dplyr)
DIR.dat <- paste(getwd(), "data", sep = "/")
FIL.txt <- paste(DIR.dat, "household_power_consumption.txt", sep = "/")
FIL.tmp <- tempfile()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              destfile = FIL.tmp, method = "curl")
unzip(zipfile = FIL.tmp, exdir = DIR.dat)
unlink(FIL.tmp)

epc <- read.csv2(FIL.txt,
                 col.names = c("dat", "tim", "gap", "grp", "vlt", "gnt", "sm1", "sm2", "sm3")) %>%
        mutate(dat = as.Date(dat, format = "%m/%d/%Y")) %>%
        filter(dat == "2007-02-01" | dat == "2007-02-02") %>%
        mutate(tim = as.POSIXct(paste(as.character(dat), tim), format = "%Y-%m-%d %H:%M:%S"),
               gap = as.numeric(levels(gap))[gap],
               grp = as.numeric(levels(grp))[grp],
               vlt = as.numeric(levels(vlt))[vlt],
               gnt = as.numeric(levels(gnt))[gnt],
               sm1 = as.numeric(levels(sm1))[sm1],
               sm2 = as.numeric(levels(sm2))[sm2],
               sm3 = as.numeric(levels(sm3))[sm3])
attach(epc, warn.conflicts = FALSE)

png(file = "plot4.png")
op <- par(mfrow = c(2, 2)) 
plot(tim, gap,
               type = "l",
               xlab = "",
              ylab  = "Global Active Power")
plot(tim, vlt,
               type = "l", 
               xlab = "datetime",
               ylab = "Voltage")
plot(tim, sm3,
               type = "l", 
                col = "blue",
               xlab = "",
               ylab = "Energy sub metering")
legend("topright",
                lty = 1,
                cex = 0.5,
                col = c("black", "red", "blue"), 
             legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
lines(tim, sm2,
               type = "l",
                col = "red")
lines(tim, sm1,
               type = "l",
                col = "black")
plot(tim, grp,
               type = "l",
               xlab = "datetime",
               ylab = "Globa_reactive_power")

par(op)
dev.off()
detach(epc)