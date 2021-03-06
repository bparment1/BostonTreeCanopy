# spdep's original "union.nb" code
union.nb <- function (nb.obj1, nb.obj2) 
{
     if (!inherits(nb.obj1, "nb") | !inherits(nb.obj2, "nb")) {
          stop("Both arguments must be of class nb")
     }
     if (any(attr(nb.obj1, "region.id") != attr(nb.obj2, "region.id"))) {
          stop("Both neighbor objects must be \n generated from the same coordinates")
     }
     n <- length(nb.obj1)
     if (n != length(nb.obj2)) 
          stop("Both arguments must be of same length")
     if (n < 1) 
          stop("non-positive number of entities")
     card1 <- card(nb.obj1)
     card2 <- card(nb.obj2)
     new.nb <- vector(mode = "list", length = n)
     for (i in 1:n) {
          if (card1[i] == 0) {
               if (card2[i] == 0) 
                    new.nb[[i]] <- 0L
               else new.nb[[i]] <- nb.obj2[[i]]
          }
          else {
               if (card2[i] == 0) 
                    new.nb[[i]] <- nb.obj1[[i]]
               else new.nb[[i]] <- sort(union(nb.obj1[[i]], nb.obj2[[i]]))
          }
     }
     attr(new.nb, "region.id") <- attr(nb.obj1, "region.id")
     attr(new.nb, "type") <- paste("union(", attr(nb.obj1, "type"), 
                                   ",", attr(nb.obj2, "type"), ")")
     class(new.nb) <- "nb"
     new.nb
}




# this custom function will let us combine nbs of different types
custom_union.nb <- function (nb.obj1, nb.obj2) 
{
     if (!inherits(nb.obj1, "nb") | !inherits(nb.obj2, "nb")) {
          stop("Both arguments must be of class nb")
     }
     #if (any(attr(nb.obj1, "region.id") != attr(nb.obj2, "region.id"))) {
     #     stop("Both neighbor objects must be \n generated from the same coordinates")
     #}
     #n <- length(nb.obj1)
     #if (n != length(nb.obj2)) 
     #     stop("Both arguments must be of same length")
     #if (n < 1) 
     #     stop("non-positive number of entities")
     
     # generating row numbers
     length_1 <- length(nb.obj1); idx_1 <- 1:length_1
     length_2 <- length(nb.obj2); idx_2 <- 1:length_2
     
     # associating row numbers with region.id (renamed "global_id",
     # which is the row number of the original object before subsetting)
     df_1 <- data.frame(rowNum = idx_1, global_id = attr(nb.obj1, "region.id"))
     df_2 <- data.frame(rowNum = idx_2, global_id = attr(nb.obj2, "region.id"))
     
     # test for overlap between global_id's
     unique_globals <- unique(union(df_1$global_id, df_2$global_id))
     n <- length(unique_globals)
     
     card1 <- card(nb.obj1) # card returns number of neighbors
     card2 <- card(nb.obj2)
     new.nb <- vector(mode = "list", length = n)
     for (i in 1:n) {
          if (card1[i] == 0) {          # nb.obj1 with no neighs
               if (card2[i] == 0)       # nb.obj2 with no neighs
                    new.nb[[i]] <- 0L   # therefore zero
               else new.nb[[i]] <- nb.obj2[[i]] # nb.obj1 = 0 and nb.obj2 > 0, therefore take on values of nb.obj2
          }
          else {                        # nb.obj1 with > 0 neighs
               if (card2[i] == 0)       # AND nb.obj2 > 0
                    new.nb[[i]] <- nb.obj1[[i]] # herefore takes on the thoes neighs
               else new.nb[[i]] <- sort(union(nb.obj1[[i]], nb.obj2[[i]])) # fouth and final case
          }
     }
     attr(new.nb, "region.id") <- attr(nb.obj1, "region.id")
     attr(new.nb, "type") <- paste("union(", attr(nb.obj1, "type"), 
                                   ",", attr(nb.obj2, "type"), ")")
     class(new.nb) <- "nb"
     new.nb
}

new_custom_nb <- custom_union.nb(nb.obj1, nb.obj2)

listw <- nb2listw(new_custom_nb)


