####  eval / parse / deparse / substitute  etc

set.seed(2017-08-24) # as we will deparse all objects *and* use *.Rout.save
.proctime00 <- proc.time() # start timing

##- From: Peter Dalgaard BSA <p.dalgaard@biostat.ku.dk>
##- Subject: Re: source() / eval() bug ??? (PR#96)
##- Date: 20 Jan 1999 14:56:24 +0100
e1 <- parse(text='c(F=(f <- .3), "Tail area" = 2 * if(f < 1) 30 else 90)')[[1]]
e1
str(eval(e1))
mode(e1)

( e2 <- quote(c(a=1,b=2)) )
names(e2)[2] <- "a b c"
e2
parse(text=deparse(e2))

##- From: Peter Dalgaard BSA <p.dalgaard@biostat.ku.dk>
##- Date: 22 Jan 1999 11:47

( e3 <- quote(c(F=1,"tail area"=pf(1,1,1))) )
eval(e3)
names(e3)

names(e3)[2] <- "Variance ratio"
e3
eval(e3)


##- From: Peter Dalgaard BSA <p.dalgaard@biostat.ku.dk>
##- Date: 2 Sep 1999

## The first failed in 0.65.0 :
attach(list(x=1))
evalq(dim(x) <- 1,as.environment(2))
dput(get("x", envir=as.environment(2)), control="all")

e <- local({x <- 1;environment()})
evalq(dim(x) <- 1,e)
dput(get("x",envir=e), control="all")

### Substitute, Eval, Parse, etc

## PR#3 : "..." matching
## Revised March 7 2001 -pd
A <- function(x, y, ...) {
    B <- function(a, b, ...) { match.call() }
    B(x+y, ...)
}
(aa <- A(1,2,3))
all.equal(as.list(aa),
          list(as.name("B"), a = expression(x+y)[[1]], b = 3))
(a2 <- A(1,2, named = 3)) #A(1,2, named = 3)
all.equal(as.list(a2),
          list(as.name("B"), a = expression(x+y)[[1]], named = 3))

CC <- function(...) match.call()
DD <- function(...) CC(...)
a3 <- DD(1,2,3)
all.equal(as.list(a3),
          list(as.name("CC"), 1, 2, 3))

## More dots issues: March 19 2001 -pd
## Didn't work up to and including 1.2.2

f <- function(...) {
	val <- match.call(expand.dots=FALSE)$...
        x <- val[[1]]
	eval.parent(substitute(missing(x)))
}
g <- function(...) h(f(...))
h <- function(...) list(...)
k <- function(...) g(...)
X <- k(a=)
all.equal(X, list(TRUE))

## Bug PR#24
f <- function(x,...) substitute(list(x,...))
deparse(f(a, b)) == "list(a, b)" &&
deparse(f(b, a)) == "list(b, a)" &&
deparse(f(x, y)) == "list(x, y)" &&
deparse(f(y, x)) == "list(y, x)"

tt <- function(x) { is.vector(x); deparse(substitute(x)) }
a <- list(b=3); tt(a$b) == "a$b" # tends to break when ...


## Parser:
1 <
    2
2 <=
    3
4 >=
    3
3 >
    2
2 ==
    2
## bug till ...
1 !=
    3

all(NULL == NULL)

## PR #656 (related)
u <- runif(1);	length(find(".Random.seed")) == 1

MyVaR <<- "val";length(find("MyVaR")) == 1
rm(MyVaR);	length(find("MyVaR")) == 0


## Martin Maechler: rare bad bug in sys.function() {or match.arg()} (PR#1409)
callme <- function(a = 1, mm = c("Abc", "Bde")) {
    mm <- match.arg(mm); cat("mm = "); str(mm) ; invisible()
}
## The first two were as desired:
callme()
callme(mm="B")
mycaller <- function(x = 1, callme = pi) { callme(x) }
mycaller()## wrongly gave `mm = NULL'  now = "Abc"

CO <- utils::capture.output

## Garbage collection  protection problem:
if(FALSE) ## only here to be run as part of  'make test-Gct'
    gctorture() # <- for manual testing
x <- c("a", NA, "b")
fx <- factor(x, exclude="")
ST <- if(interactive()) system.time else invisible
ST(r <- replicate(20, CO(print(fx))))
table(r[2,]) ## the '<NA>' levels part would be wrong occasionally
stopifnot(r[2,] == "Levels: a b <NA>") # in case of failure, see r[2,] above


## withAutoprint() : must *not* evaluate twice *and* do it in calling environment:
stopifnot(
    identical(
	## ensure it is only evaluated _once_ :
	CO(withAutoprint({ x <- 1:2; cat("x=",x,"\n") }))[1],
	paste0(getOption("prompt"), "x <- 1:2"))
   ,
    ## need "enough" deparseCtrl for this:
    grepl("1L, NA_integer_", CO(withAutoprint(x <- c(1L, NA_integer_, NA))))
   ,
    identical(CO(r1 <- withAutoprint({ formals(withAutoprint); body(withAutoprint) })),
	      CO(r2 <- source(expr = list(quote(formals(withAutoprint)),
					  quote(body(withAutoprint)) ),
			      echo=TRUE))),
    identical(r1,r2)
)
## partly failed in R 3.4.0 alpha
rm(CO) # as its deparse() depends on if utils was installed w/ keep.source.pkgs=TRUE
rm(r2)

srcdir <- file.path(Sys.getenv("SRCDIR"), "eval-fns.R")
source(if(file.exists(srcdir)) srcdir else "./eval-fns.R", echo = TRUE)
rm("srcdir")

library(stats)
## some more "critical" cases
nmdExp <- expression(e1 = sin(pi), e2 = cos(-pi))
xn <- setNames(3.5^(1:3), paste0("3½^",1:3)) # 3.5: so have 'show'
## "" in names :
x0 <- xn; names(x0)[2] <- ""
en0  <- setNames(0L, "")
en12 <- setNames(1:2, c("",""))
en24 <- setNames(2:4, c("two","","vier"))
enx0  <- `storage.mode<-`(en0, "double")
enx12 <- `storage.mode<-`(en12,"double")
enx24 <- `storage.mode<-`(en24,"double")
L1 <- list(c(A="Txt"))
L2 <- list(el = c(A=2.5))
## "m:n" named integers and _inside list_
i6 <- setNames(5:6, letters[5:6])
L4  <- list(ii = 5:2) # not named
L6  <- list(L = i6)
L6a <- list(L = structure(rev(i6), myDoc = "info"))
## these must use structure() to keep NA_character_ name:
LNA <- setNames(as.list(c(1,2,99)), c("A", "NA", NA))
iNA <- unlist(LNA)
missL <- setNames(rep(list(alist(.=)$.), 3), c("",NA,"c"))
## empty *named* atomic vectors
i00 <- setNames(integer(), character()); i0 <- structure(i00, foo = "bar")
L00 <- setNames(logical(), character()); L0 <- structure(L00, class = "Logi")
r00 <- setNames(raw(), character())
sii <- structure(4:7, foo = list(B="bar", G="grizzly",
                                 vec=c(a=1L,b=2L), v2=i6, v0=L00))
fm <- y ~ f(x)
lf <- list(ff = fm, osf = ~ sin(x))
stopifnot(identical(deparse(lf, control="all"), # no longer quote()s
		    deparse(lf)))
abc <- setNames(letters[1:4], c("one", "recursive", "use.names", "four"))
r13 <- i13 <- setNames(1:3, names(abc)[3:1]); mode(r13) <- "double"

## Creating a collection of S4 objects, ensuring deparse <-> parse are inverses
library(methods)
example(new) # creating t1 & t2 at least
## an S4 object of type "list" of "mp1" objects [see pkg 'Rmpfr']:
setClass("mp1", slots = c(prec = "integer", d = "integer"))
setClass("mp", contains = "list", ## of "mp1" entries:
         validity = function(object) {
	     if(all(vapply(object@.Data, class, "") == "mp1"))
		 return(TRUE)
	     ## else
		 "Not all components are of class 'mp1'"
	 })
validObject(m0 <- new("mp"))
validObject(m1 <- new("mp", list(new("mp1"), new("mp1", prec=1L, d = 3:5))))
typeof(m1)# "list", not "S4"
dput(m1) # now *is* correct -- will be check_EPD()ed below
##
mList <- setClass("mList", contains = "list")
mForm <- setClass("mForm", contains = "formula")
mExpr <- setClass("mExpr", contains = "expression")
## more to come
attrS4 <- function(x)
    c(S4 = isS4(x), obj= is.object(x), type.S4 = typeof(x) == "S4")
attrS4(ml <- mList(list(1, letters[1:3])))# use *unnamed* list
attrS4(mf <- mForm( ~ f(x)))
attrS4(E2 <- mExpr(expression(x^2)))
stopifnot(identical(mf, eval(parse(text=deparse(mf)))))
stopifnot(identical(mf, eval(parse(text=deparse(mf, control="all"))))) # w/ a warning


## Action!  Check deparse <--> parse  consistency for *all* objects:
runEPD_checks()

summary(warnings())
## "dput    may be incomplete"
## "deparse may be incomplete"


## at the very end
cat('Time elapsed: ', proc.time() - .proctime00,'\n')
