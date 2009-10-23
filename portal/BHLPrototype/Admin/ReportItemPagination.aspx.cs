using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using CustomDataAccess;
using MOBOT.Utility;
using SortOrder = CustomDataAccess.SortOrder;
using Paige = MOBOT.BHL.DataObjects.Page;

namespace MOBOT.BHL.Web.Admin
{
	public partial class ReportItemPagination : System.Web.UI.Page
	{
		private ItemComparer.CompareEnum _sortColumn = ItemComparer.CompareEnum.ItemID;
		private SortOrder _sortOrder = SortOrder.Ascending;

		protected void Page_Load( object sender, EventArgs e )
		{
			if ( IsPostBack )
			{
				if ( ViewState[ "SortColumn" ] != null )
				{
					_sortColumn = (ItemComparer.CompareEnum)ViewState[ "SortColumn" ];
					_sortOrder = (SortOrder)ViewState[ "SortOrder" ];
				}
			}
			else
			{
				search();
			}

		}

		private void search()
		{
			BHLProvider bp = new BHLProvider();
			CustomGenericList<Item> items = bp.ItemSelectPaginationReport();
			Session[ "Items" ] = items;
			bindItemData();
		}

		private void bindItemData()
		{
			CustomGenericList<Item> items = (CustomGenericList<Item>)Session[ "Items" ];
			ItemComparer comp = new ItemComparer( (ItemComparer.CompareEnum)_sortColumn, _sortOrder );
			items.Sort( comp );
			itemList.DataSource = items;
			itemList.DataBind();
		}

		#region Event handlers

		protected void itemList_Sorting( object sender, GridViewSortEventArgs e )
		{
			ItemComparer.CompareEnum sortColumn = _sortColumn;

			if ( e.SortExpression.Equals( "ItemID" ) )
			{
				_sortColumn = ItemComparer.CompareEnum.ItemID;
			}
			else if ( e.SortExpression.Equals( "BarCode" ) )
			{
				_sortColumn = ItemComparer.CompareEnum.BarCode;
			}
			else if ( e.SortExpression.Equals( "PaginationStatusName" ) )
			{
				_sortColumn = ItemComparer.CompareEnum.PaginationStatusName;
			}
			else if ( e.SortExpression.Equals( "PaginationStatusDate" ) )
			{
				_sortColumn = ItemComparer.CompareEnum.PaginationStatusDate;
			}

			if ( sortColumn == _sortColumn )
			{
				if ( _sortOrder == SortOrder.Descending )
				{
					_sortOrder = SortOrder.Ascending;
				}
				else
				{
					_sortOrder = SortOrder.Descending;
				}
			}
			else
			{
				_sortOrder = SortOrder.Ascending;
			}

			ViewState[ "SortColumn" ] = _sortColumn;
			ViewState[ "SortOrder" ] = _sortOrder;

			bindItemData();
		}

		protected void itemList_RowDataBound( object sender, GridViewRowEventArgs e )
		{
			if ( e.Row.RowType == DataControlRowType.Header )
			{
				Image img = new Image();
				img.Attributes[ "style" ] = "padding-bottom:2px";
				if ( _sortOrder == SortOrder.Ascending )
				{
					img.ImageUrl = "/images/up.gif";
				}
				else
				{
					img.ImageUrl = "/Admin/images/down.gif";
				}

				int sortColumnIndex = 0;
				switch ( _sortColumn )
				{
					case ItemComparer.CompareEnum.ItemID:
						{
							sortColumnIndex = 0;
							break;
						}
					case ItemComparer.CompareEnum.BarCode:
						{
							sortColumnIndex = 1;
							break;
						}
					case ItemComparer.CompareEnum.PaginationStatusName:
						{
							sortColumnIndex = 2;
							break;
						}
					case ItemComparer.CompareEnum.PaginationStatusDate:
						{
							sortColumnIndex = 3;
							break;
						}
				}

				e.Row.Cells[ sortColumnIndex ].Controls.Add( new LiteralControl( " " ) );
				e.Row.Cells[ sortColumnIndex ].Controls.Add( img );
				e.Row.Cells[ sortColumnIndex ].Wrap = false;
			}
		}

		#endregion

	}
}
