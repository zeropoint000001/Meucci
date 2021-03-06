#' This script computes the correlation between explicit, time-series industry factor returns and implicit, 
#' cross-section industry factor returns, as described in A. Meucci, "Risk and Asset Allocation", Springer, 2005,
#'  Chapter 3.
#'
#' @references
#' A. Meucci - "Exercises in Advanced Risk and Portfolio Management" \url{http://symmys.com/node/170},
#' "E 124 - Cross-section factors: comparison cross-section with time-series industry factors". 
#' See Meucci's script for "S_TimeSeriesVsCrossSectionIndustries.m"
#'
#' A. Meucci - "Review of linear factor models: Unexpected common features and the systematic-plus-idiosyncratic myth", 2010. \url{http://www.symmys.com/node/336}
#'
#' @author Xavier Valls \email{flamejat@@gmail.com}
##################################################################################################################
### Load data
# loads weekly stock returns X and indices stock returns F
data("securitiesTS");
Data_Securities = securitiesTS$data[ , -1 ]; # 1st column is date

data("sectorsTS");
Data_Sectors = sectorsTS$data[ , -(1:2) ];

data("securitiesIndustryClassification");
Securities_IndustryClassification = securitiesIndustryClassification$data;

##################################################################################################################
# Linear returns for stocks
X = ( Data_Securities[ -1, ] - Data_Securities[ -nrow(Data_Securities),  ] ) / Data_Securities[ -nrow(Data_Securities),  ];

# explicit, time-series industry factor returns
F_ts = (Data_Sectors[ -1, ] - Data_Sectors[ -nrow(Data_Sectors),  ] ) / Data_Sectors[ -nrow(Data_Sectors),  ] ; 
K = ncol(F_ts);

# implicit, cross-section industry factor returns
Sigma_X = (dim(X)[1]-1)/dim(X)[1] * cov(X);
B    = Securities_IndustryClassification;
Phi = diag(1 / diag( Sigma_X ), length(diag( Sigma_X ) ) );
tmp = t(B) %*% Phi %*% B ;
F_cs   = t( diag( diag(tmp) ^( -1 ), dim(tmp) ) %*% t(B) %*% Phi %*% t(X));


##################################################################################################################
### Correlation analysis
Corr_cs_ts = matrix( 0, K, 1 );
for( k in 1 : K )
{
    C = cor( cbind( F_cs[ , k], F_ts[ , k ] ));
    Corr_cs_ts[ k ] = C[ 1, 2 ];
}

# time series factors are highly correlated with their cross-sectional counterparts
dev.new();
hist( Corr_cs_ts, seq( 0, 1, 0.1), xlim = c(-0.2, 0.2));

