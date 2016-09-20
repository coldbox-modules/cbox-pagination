# Paging service

Conversion Author:  Robert Cruz
Conversion of original Paging plugin to coldbox 4 paging service utility.  Drop in your models folder.
Also now has links to go to first and last record in addition to next and previous links.

To use this service you need to create some settings in your `coldbox.cfc` and some
css entries.

## COLDBOX SETTINGS
- *PagingMaxRows* : The maximum number of rows per page.
- *PagingBandGap* : The maximum number of pages in the page carrousel

## CSS SETTINGS:
Now using bootstraps pagination css
- `.nav aria-label="Page navigation"` - The div container
- `.pagingTabsTotals` - The totals
- `.pagination` - The carrousel

## Usage

To use. You must use a `page` variable to move from page to page.
ex: `index.cfm?event=users.list&page=2`

In your handler you must calculate the boundaries to push into your paging query.
inject the paging service:

```
property name="pagingService" inject="PagingService@cbpagination";
prc.boundaries = pagingServince.getBoundaries();
```

Gives you a struct:
- `[startrow]` : the startrow to use
- `[maxrow]` : the max row in this recordset to use. Ex: [startrow=11][maxrow=20] if we are using a PagingMaxRows of 10
- `FoundRows` = The total rows found in the recordset
- `link` = The link to use for paging, including a placeholder for the page `@page@` (`index.cfm?event=users.list&page=@page@`)

To RENDER the paging carousel:
Get an instance of the paging model:  

```
p = getInstance( 'PagingService@cbpagination' );
```

Call the rederit function: 

```
p.renderit(  FoundRows, link, page);
```
