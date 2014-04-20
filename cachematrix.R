## The function makeCacheMatrix, creates a special "matrix", which is
## really a list containing a function to:

## 1) set the value of the matrix to be inverted x
## 2) get the value of the matrix to be inverted x
## 3) set the value of the inverse matrix inv_matrix
## 4) get the value of the inverse matrix inv_matrix

makeCacheMatrix <- function(x = matrix()) {
  
    inv_matrix <- NULL
    ## This sets the value value of the matrix to be inverted 'x'.
    set <- function(y) {
           x <<- y
           inv_matrix <<- NULL
    }
    
    ## This function gets the value of the matrix to be inverted 'x'. 
    get <- function() x
    
    ## This function sets the value of the inverse matrix 'inv_matrix'. 
    setinverse <- function(inverse) inv_matrix <<- inverse
    
    ## This function gets the value of the inverse matrix 'inv_matrix'.
    getinverse <- function() inv_matrix
  
    ## The following is the special "matrix" which in reality is a list:  
    list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)
  
}


## The following function calculates the inverse of the special "matrix"
# created with the above function. However, it first checks to see if the
# inverse has already been calculated. If so, it `get`s the inverse from the
# cache and skips the computation. Otherwise, it calculates the inverse of
# the data and sets the value of the inverse in the cache via the `setinverse`
# function.
cacheSolve <- function(x, ...) {
  ## Return a matrix that is the inverse of 'x'
  
  inv_matrix <- x$getinverse()
  if(!is.null(inv_matrix)) {
    message("getting cached inverse matrix")
    return(inv_matrix)
  }
  x <- x$get()    # Get the matrix x to be inverted.
  inv_matrix <- solve(x)   # Invert matrix x and assign the value of the inverse to m.
  x$setinverse(inv_matrix) # Cache (store) the inverse matrix 'inv_matrix'.
  inv_matrix
  
}
