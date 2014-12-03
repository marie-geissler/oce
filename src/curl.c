/* vim: set noexpandtab shiftwidth=2 softtabstop=2 tw=70: */

// Curl calculated with first difference on 5-point stencil.

#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>

//#define DEBUG 1

/* 

x <- 1:3
y <- 1:4
mx <- matrix(1:12, nrow=3, byrow=TRUE)
my <- matrix(1:12, nrow=3, byrow=FALSE)
system("R CMD SHLIB curl.c"); dyn.load('curl.so'); curl<-.Call("curl1",mx,my,x,y,TRUE)
x
y
curl


lat <- c(85,82.5,80,72.5)
lon <- c(160,162.5,165,167.5)
u <- matrix(c(1,6,9,3,7,11,14,10,4,13,2,12,16,8,15,5), nrow=4, ncol=4, byrow=T)
v <- matrix(c(3,20,1,14,1,19,2,6,21,13,28,16,24,4,15,17), nrow=4, ncol=4, byrow=T)
system("R CMD SHLIB curl.c"); dyn.load('curl.so')
.Call("curl2", u,v,lon,lat,TRUE)




*/

// The first macro uses nrow-1 for a centred matrix.
// #define ix2(i, j) ((i) + ((nrow)-1) * (j))

SEXP curl1(SEXP mx, SEXP my, SEXP x, SEXP y, SEXP geographical)
{
#define ix(i, j) ((i) + (nrow) * (j))
  double R = 6371.0e3; // FIXME: could be an argument but there seems little need
  PROTECT(mx = AS_NUMERIC(mx));
  PROTECT(my = AS_NUMERIC(my));
  PROTECT(x = AS_NUMERIC(x));
  PROTECT(y = AS_NUMERIC(y));
  PROTECT(geographical = AS_NUMERIC(geographical));
  int nrow = INTEGER(GET_DIM(mx))[0];
  if (nrow != INTEGER(GET_DIM(my))[0]) error("matrices mx and my must have nrow");
  int ncol = INTEGER(GET_DIM(mx))[1];
  if (ncol != INTEGER(GET_DIM(my))[1]) error("matrices mx and my must have ncol");
  if (LENGTH(x) != nrow) error("matrix has %d rows, but length(x) is %d", nrow, LENGTH(x));
  if (LENGTH(y) != ncol) error("matrix has %d cols, but length(y) is %d", ncol, LENGTH(y));
  double *mxp = REAL(mx);
  double *myp = REAL(my);
  double *xp = REAL(x);
  double *yp = REAL(y);
  double *geographicalp = REAL(geographical);
  int isGeographical = 0.0 != *geographicalp;
  
  // Construct curl matrix.
  SEXP curl;
  PROTECT(curl = allocMatrix(REALSXP, nrow, ncol));
  double *curlp = REAL(curl);

  // SCHEME: x or longitude is indexed by 0 <= i <= (nrow-1), while
  //         y or latitude  is indexed by 0 <= j <= (ncol-1).
#ifdef DEBUG
  // set to NA so we can see if we are failing to fill grid correctly
  for (int i = 0; i < nrow; i++) 
    for (int j = 0; j < ncol; j++) 
      curlp[ix(i,j)] = NA_REAL; 
#endif
  double xfac=1.0, yfac = 1.0;
  if (isGeographical)
    yfac = R * M_PI / 180.0;
  for (int j = 1; j < ncol-1; j++) {
    if (isGeographical)
      xfac = R * M_PI / 180.0 * cos(yp[j]*M_PI/180.0);
    for (int i = 1; i < nrow-1; i++) {
      // Calculate first difference with a 5-point stencil, e.g. infer d/dy by subtracting 
      // the value at i+1 from the value at i-1 etc.
      double dmxdy = (mxp[ix(i,j+1)] - mxp[ix(i,j-1)]) / (yp[j+1] - yp[j-1]) / yfac;
      double dmydx = (myp[ix(i+1,j)] - myp[ix(i-1,j)]) / (xp[i+1] - xp[i-1]) / xfac;
      curlp[ix(i, j)] = dmydx - dmxdy;
#ifdef DEBUG
      Rprintf("x[%d,%d]=(%.1f,%.1f), y[%d,%d]=(%.1f,%.1f)\n", j-1, j+1, xp[j-1], xp[j+1], i-1,i+1,yp[i-1], yp[i+1]);
      Rprintf("  dmydx=%.2e; dmxdy=%.2e; curl=%.1e\n", dmydx, dmxdy, curlp[ix(i,j)]);
#endif
    }
  }
  // bottom and top: copy neighbours above and below
  for (int i = 1; i < nrow-1; i++) {
      curlp[ix(i, 0)] = curlp[ix(i, 1)];
      curlp[ix(i, ncol-1)] = curlp[ix(i, ncol-2)];
  }
  // left and right: copy neighbors to right and left
  for (int j = 1; j < ncol-1; j++) {
      curlp[ix(0, j)] = curlp[ix(1, j)];
      curlp[ix(nrow-1, j)] = curlp[ix(nrow-2, j)];
  }
  // corners: use diagonal neighbour
  curlp[ix(0,0)] = curlp[ix(1,1)];
  curlp[ix(0,ncol-1)] = curlp[ix(1,ncol-2)];
  curlp[ix(nrow-1,0)] = curlp[ix(nrow-2,1)];
  curlp[ix(nrow-1,ncol-1)] = curlp[ix(nrow-2,ncol-2)];

  // Construct list for the return value.
  SEXP lres;
  SEXP lres_names;
  PROTECT(lres = allocVector(VECSXP, 3));
  PROTECT(lres_names = allocVector(STRSXP, 3));
  SET_VECTOR_ELT(lres, 0, x);
  SET_VECTOR_ELT(lres, 1, y);
  SET_STRING_ELT(lres_names, 0, mkChar("x"));
  SET_STRING_ELT(lres_names, 1, mkChar("y"));
  SET_VECTOR_ELT(lres, 2, curl);
  SET_STRING_ELT(lres_names, 2, mkChar("curl"));
  setAttrib(lres, R_NamesSymbol, lres_names);
  UNPROTECT(8);
  return(lres);
#undef ix
}

SEXP curl2(SEXP mx, SEXP my, SEXP x, SEXP y, SEXP geographical)
{
#define ix(i, j) ((i) + (nrow-1) * (j))
  double R = 6371.0e3; // FIXME: could be an argument but there seems little need
  PROTECT(mx = AS_NUMERIC(mx));
  PROTECT(my = AS_NUMERIC(my));
  PROTECT(x = AS_NUMERIC(x));
  PROTECT(y = AS_NUMERIC(y));
  PROTECT(geographical = AS_NUMERIC(geographical));
  int nrow = INTEGER(GET_DIM(mx))[0];
  if (nrow != INTEGER(GET_DIM(my))[0]) error("matrices mx and my must have nrow");
  int ncol = INTEGER(GET_DIM(mx))[1];
  if (ncol != INTEGER(GET_DIM(my))[1]) error("matrices mx and my must have ncol");
  if (LENGTH(x) != nrow) error("matrix has %d rows, but length(x) is %d", nrow, LENGTH(x));
  if (LENGTH(y) != ncol) error("matrix has %d cols, but length(y) is %d", ncol, LENGTH(y));
  double *mxp = REAL(mx);
  double *myp = REAL(my);
  double *xp = REAL(x);
  double *yp = REAL(y);
  double *geographicalp = REAL(geographical);
  int isGeographical = 0.0 != *geographicalp;
  
  // Construct curl matrix.
  SEXP curl;
  // README.CL: nrow and ncol will need adjustment in next line
  PROTECT(curl = allocMatrix(REALSXP, nrow-1, ncol-1));
  double *curlp = REAL(curl);

  // SCHEME: x or longitude is indexed by 0 <= i <= (nrow-1), while
  //         y or latitude  is indexed by 0 <= j <= (ncol-1).
#ifdef DEBUG
  // set to NA so we can see if we are failing to fill grid correctly
  for (int i = 0; i < nrow-1; i++) 
    for (int j = 0; j < ncol-1; j++) 
      curlp[ix(i,j)] = NA_REAL; 
#endif
  double xfac=1.0, yfac = 1.0;
  double xsign = (xp[1] > xp[0])? 1.0 : -1.0;
  double ysign = (yp[1] > yp[0])? 1.0 : -1.0;
  if (isGeographical)
    yfac = ysign * R * M_PI / 180.0;
  for (int j = 0; j < ncol-1; j++) {
    if (isGeographical)
    xfac = xsign * R * M_PI / 180.0 * cos(yp[j]*M_PI/180.0);
    for (int i = 0; i < nrow-1; i++) {
      // Calculate first difference with a 5-point stencil, e.g. infer d/dy by subtracting 
      // the value at i+1 from the value at i-1 etc.
      double dmxdy = (mxp[ix(i  , j+1)] - mxp[ix(i  , j-1)]) / (yfac * (yp[j+1] - yp[j-1]));
      double dmydx = (myp[ix(i+1, j  )] - myp[ix(i-1, j  )]) / (xfac * (xp[i+1] - xp[i-1]));
      curlp[ix(i, j)] = dmydx - dmxdy;
#ifdef DEBUG
      Rprintf("x[%d,%d]=(%.1f,%.1f), y[%d,%d]=(%.1f,%.1f)\n", j-1, j+1, xp[j-1], xp[j+1], i-1,i+1,yp[i-1], yp[i+1]);
      Rprintf("  dmydx=%.2e; dmxdy=%.2e; curl=%.1e\n", dmydx, dmxdy, curlp[ix(i,j)]);
#endif
    }
  }
  // Construct xnew and ynew, which we will return.
  SEXP xnew, ynew;
  PROTECT(xnew = allocVector(REALSXP, nrow-1));
  PROTECT(ynew = allocVector(REALSXP, ncol-1));
  double *xnewp = REAL(xnew);
  double *ynewp = REAL(ynew);
  for (int i = 0; i < nrow - 1; i++)
    xnewp[i] = 0.5 * (xp[i] + xp[i+1]);
  for (int j = 0; j < ncol - 1; j++)
    ynewp[j] = 0.5 * (yp[j] + yp[j+1]);

  // Construct list for the return value.
  SEXP lres;
  SEXP lres_names;
  PROTECT(lres = allocVector(VECSXP, 3));
  PROTECT(lres_names = allocVector(STRSXP, 3));
  SET_VECTOR_ELT(lres, 0, xnew);
  SET_VECTOR_ELT(lres, 1, ynew);
  SET_STRING_ELT(lres_names, 0, mkChar("x"));
  SET_STRING_ELT(lres_names, 1, mkChar("y"));
  SET_VECTOR_ELT(lres, 2, curl);
  SET_STRING_ELT(lres_names, 2, mkChar("curl"));
  setAttrib(lres, R_NamesSymbol, lres_names);
  UNPROTECT(10);
  return(lres);
#undef ix
}

