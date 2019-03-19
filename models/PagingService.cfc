/**
* Copyright Ortus Solutions, Corp
* www.ortussolutions.com
*
* paging service
*
* Conversion Author:  Robert Cruz
* Conversion of original Paging plugin to coldbox 4 paging service utility.  Drop in your models folder.
* Also now has links to go to first and last record in addition to next and previous inks.
*
*/
component output="false"  {
	
	// injections - get the settings necessary for paging to work
	property name="pagingMaxRows" inject="coldbox:setting:pagingMaxRows";
	property name="PagingBandGap" inject="coldbox:setting:PagingBandGap";
	//Constructor

	function init(){
		return this;
	}

	numeric function  getPagingMaxRows (pagingMaxRows) {
		if ( isDefined ( arguments.pagingMaxRows ) ) {
			pagingMaxRows = arguments.pagingMaxRows;
		}

		return PagingMaxRows = pagingMaxRows;
	}

	numeric function  getPagingBandGap () {
		return PagingBandGap = PagingBandGap;
	}
	
	any function  getBoundaries (page,pagingMaxRows) {
			var boundaries = structnew();
			//var page = arguments.page;
			var maxRows = getPagingMaxRows (pagingMaxRows);
			
			/* Check for Override need to come back to this */
			if( structKeyExists(arguments,"PagingMaxRows") ){
				maxRows = arguments.pagingMaxRows;
			}
						
			boundaries.startrow = (arguments.page * maxrows - maxRows)+1;
			boundaries.maxrow = boundaries.startrow + maxRows - 1;
		
			return boundaries;
	}
	
	any function renderit (FoundRows,link,page,pagingMaxRows,pagingBandGap) {
		
		var pagingTabs = "";
		var maxRows = getPagingMaxRows(pagingMaxRows);
		var bandGap = getPagingBandGap();
		var totalPages = 0;
		var theLink = arguments.link;
		//Paging vars --->
		var currentPage = arguments.page;
		var pageFrom = 0;
		var pageTo = 0;
		var pageIndex = 0;
		
		/* Check for Override need to come back to this */
		if( structKeyExists(arguments,"PagingBandGap") ){
			bandGap = arguments.pagingBandGap;
		}
		if ( arguments.foundRows neq 0 ) {
			totalPages = ceiling( arguments.FoundRows / maxRows );
		}
		// output pagination totals and carousel
		savecontent variable="pagingtabs" {
			writeOutput( '<nav aria-label="Page navigation">' );
			// output paging totals
			writeOutput( '<div class="pagingTabsTotals"><strong>Total Records: </strong>' & #numberFormat(arguments.FoundRows, ",___")# &'&nbsp;&nbsp;' & '<strong>Total Pages: </strong>' & #numberFormat(totalPages, ",___")# & '</div>');
			//start the pagination carousel
			writeOutput( '<ul class="pagination">' );
			// PREVIOUS PAGE --->
			if ( currentPage-1 gt 0 ) {
				writeOutput( '<li class="page-item"><a class="page-link" href="#replace(theLink,"@page@",1)#" aria-label="first"><span aria-hidden="true">&laquo;&laquo;</span></a></li>' );
				writeOutput( '<li class="page-item"><a class="page-link" href="#replace(theLink,"@page@",currentPage-1)#" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>' );
			} else {
				writeOutput ( '<li class="page-item disabled"><span aria-hidden="true" class="page-link">&laquo;&laquo;</span></li><li class="page-item disabled"><span aria-hidden="true" class="page-link">&laquo;</span></li>' );
			}
			// Calcualte PageFrom Carrousel --->
			pageFrom=1;
			
			if ( (currentPage-bandGap) gt 1 ) {
				pageFrom = currentPage-bandGap;
				writeOutput( '<li class="page-item"><a class="page-link" href="#replace(theLink,"@page@",1)#">1</a></li>' );
			}
			// Page TO of Carrousel --->
			pageTo = (currentPage+bandGap);
			
			if ( ( currentPage + bandGap ) gt totalPages ) {
				pageTo = totalPages;
			}
			
			var pageStatusClass = "";
			//loop and create each page link
			for (
					pageIndex = pageFrom;
					pageIndex LTE pageTo;
					pageindex ++
				)
				{
					if ( currentPage eq pageIndex ) {
						pageStatusClass='class="active page-item"';
					}
					writeOutPut ( '<li #pageStatusClass#><a class="page-link" href="#replace(theLink,"@page@",pageIndex)#"' & '>' & #numberFormat(pageIndex, ",___")# & '</a></li>');	
					pageStatusClass = "";
				}

			// End Token --->
			if ( ( currentPage + bandGap ) lt totalPages ) {
				writeOutput( '<li class="page-item"><a class="page-link" href="#replace(theLink,"@page@",totalPages)#">' & #numberFormat(totalPages, ",___")# & '</a></li>' );
			}
			
			// NEXT PAGE --->
			if ( currentPage lt totalPages ) {
				writeOutput ( '<li class="page-item"><a class="page-link" href="#replace(theLink,"@page@",currentPage+1)#" aria-hidden="true"><span aria-hidden="true">&raquo;</span></a></li>' );
				writeOutput ( '<li class="page-item"><a class="page-link" href="#replace(theLink,"@page@",totalPages)#" aria-hidden="true"><span aria-hidden="true">&raquo;&raquo;</span></a></li>' );
			} else {
				writeOutput ( '<li class="page-item disabled"><span aria-hidden="true" class="page-link">&raquo;</span></li>' );
				writeOutput ( '<li class="page-item disabled"><span aria-hidden="true" class="page-link">&raquo;&raquo;</span></li>' )
			}

			writeOutPut( '</ul>' );
			writeOutPut( '</nav>' );
		}
		// this return is for testing only
		return pagingtabs;
	}
}
