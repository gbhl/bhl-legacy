<%@ Page Language="C#" MasterPageFile="/Admin/Admin.Master" AutoEventWireup="True" Codebehind="TitleEdit.aspx.cs" Inherits="MOBOT.BHL.Web.Admin.TitleEdit"
	ValidateRequest="false" EnableEventValidation="false" %>

<%@ Register Src="/Admin/Controls/ErrorControl.ascx" TagName="ErrorControl" TagPrefix="mobot" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <script language="javascript">
    function overlay() {
	    el = document.getElementById("overlayitem");
	    el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
	}
    
    function titleSearch(titleId, title) {
        if (titleId == "" && title == "") {
            alert("Please specify a Title ID or Title.");
            return;
        }

        executeServiceCall('services/titleservice.ashx?op=TitleSearch&titleID=' + titleId + '&title=' + title, showTitleList);
    }
    
    function itemSearch(titleId, marcBibId)
    {
        if (titleId == "" && marcBibId == "") {
            alert("Please specify a Title ID or MARC Bib ID.");
            return;
        }
        
        executeServiceCall('services/itemservice.ashx?op=ItemSearchByTitle&titleID=' + titleId + '&marcBibId=' + marcBibId, showItemList);
    }

    function showTitleList(result) {
        var titles = eval(result);

        // Clear rows already in table
        var tbody = document.getElementById("srchTitleTable").getElementsByTagName("tbody")[0];
        var rows = document.getElementById("srchTitleTable").getElementsByTagName("tr");
        for (var j = (rows.length - 1); j >= 2; j--) tbody.removeChild(rows[j]);
        
        // Build the table
        for (var i = 0; i < titles.length; i++) {
            var tbody = document.getElementById("srchTitleTable").getElementsByTagName("tbody")[0];
            var row = document.createElement("tr");
            row.setAttribute("align", "left");
            var td1 = document.createElement("td");
            td1.appendChild(document.createTextNode(titles[i].TitleID));
            var td2 = document.createElement("td");
            var span = document.createElement("span");
            span.setAttribute("style", "text-decoration:underline;color:#a54219;");
            span.style.cssText = "text-decoration:underline;color:#a54219;";
            span.onclick = new Function("itemSearch('" + titles[i].TitleID + "', '')");
            span.appendChild(document.createTextNode(titles[i].SortTitle));
            td2.appendChild(span);
            row.appendChild(td1);
            row.appendChild(td2);
            tbody.appendChild(row);
        }

        // Display the table
        document.getElementById('srchResultTable').style.display = 'none';
        document.getElementById('srchTitleTable').style.display = 'block';
    }

    function showItemList(result)
    {
        var items = eval(result);
        
        // Clear rows already in table
        var tbody = document.getElementById("srchResultTable").getElementsByTagName("tbody")[0];
        var rows = document.getElementById("srchResultTable").getElementsByTagName("tr");
        for (var j = (rows.length - 1); j >= 2; j--) tbody.removeChild(rows[j]);
        
        // Build the table
        for (var i = 0; i < items.length; i++)
        {
            var tbody = document.getElementById("srchResultTable").getElementsByTagName("tbody")[0];
            var row = document.createElement("tr");
            row.setAttribute("align", "left");
            var td1 = document.createElement("td");
            td1.appendChild(document.createTextNode(items[i].ItemID));
            var td2 = document.createElement("td");
            td2.appendChild(document.createTextNode(items[i].BarCode));
            var td3 = document.createElement("td");
            td3.appendChild(document.createTextNode(items[i].Volume));
            var td4 = document.createElement("td");
            var input = document.createElement("input");
            input.setAttribute("type", "checkbox");
            input.setAttribute("id", "makePrimaryCheckbox");
            input.setAttribute("name", "makePrimaryCheckbox");
            input.setAttribute("value", items[i].ItemID);
            td4.appendChild(input);
            row.appendChild(td1);
            row.appendChild(td2);
            row.appendChild(td3);
            row.appendChild(td4);
            tbody.appendChild(row);
        }

        // Display the table
        document.getElementById('srchTitleTable').style.display = 'none';
        document.getElementById('srchResultTable').style.display = 'block';
    }

    function executeServiceCall(url, callback)
    {
        var request = createXMLHttpRequest();
        request.open("GET", url, true);
        request.onreadystatechange = function() {
            if (request.readyState == 4)
            {
                if (request.status == 200) {
                    var result = eval('(' + request.responseText + ')');
                    callback(result);
                }
            }
        }
        request.send(null);
    }

    function createXMLHttpRequest() {
        if (typeof XMLHttpRequest != "undefined") {
            return new XMLHttpRequest();
        } else if (typeof ActiveXObject != "undefined") {
            return new ActiveXObject("Microsoft.XMLHTTP");
        } else {
            throw new Error("XMLHttpRequest not supported");
        }
    }
    
    function keyDownHandler(event, btn)
    {
        // process only the Enter key
        if ((document.all ? event.keyCode : event.which) == 13)
        {
            // cancel the default submit
            event.preventDefault ? event.preventDefault() : event.returnValue = false;
            event.cancel = true;
            // submit the form by programmatically clicking the specified button
            btn.click();
        }
    }
    </script>
	<a href="/Admin/Dashboard.aspx">&lt; Return to Dashboard</a><br />
	<a href="/Admin/TitleSearch.aspx">&lt; Find a Different Title</a><br />
	<br />
	<span class="pageHeader">Title</span><hr />
	<br />
	<mobot:ErrorControl runat="server" id="errorControl"></mobot:ErrorControl>
	<asp:Literal id="litMessage" runat="server"></asp:Literal>
	<br />
	<div class="box" style="padding: 5px;margin-right:5px">
		<table cellpadding="4" width="100%">
			<tr>
				<td style="white-space: nowrap" align="right" class="dataHeader">
					Title ID:
				</td>
				<td style="white-space: nowrap" colspan="4" valign="middle" width="100%">
					<asp:Label ID="idLabel" runat="server" ForeColor="blue" />
					<asp:CheckBox ID="publishReadyCheckBox" runat="server" />Publish On BHL Portal
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" class="dataHeader">
					MARC Leader:
				</td>
				<td colspan="4">
					<asp:Label ID="marcLeaderLabel" runat="server" ForeColor="blue" />
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" class="dataHeader">
					MARC Bib ID:
				</td>
				<td colspan="4">
				    <asp:Label ID="marcBibIdLabel" runat="server" ForeColor="Blue"></asp:Label>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Full Title (MARC 245a,b,c):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="fullTitleTextBox" runat="server" MaxLength="8000" Width="100%" TextMode="MultiLine" Height="50px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Part/Section Number (MARC 245n):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="partNumberTextBox" runat="server" MaxLength="255" Width="400px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Part/Section Name (MARC 245p):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="partNameTextBox" runat="server" MaxLength="255" Width="400px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Short Title (MARC 245a):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="shortTitleTextBox" runat="server" MaxLength="255" Width="100%"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Sort Title:
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="sortTitleTextBox" runat="server" MaxLength="60" Width="400px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Uniform Title (MARC 130a or 240a):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="uniformTitleTextBox" runat="server" MaxLength="255" Width="100%"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Call Number (MARC 050a,b):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="callNumberTextBox" runat="server" MaxLength="100" Width="400px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Contributor:
				</td>
				<td colspan="4" style="width: 100%">
					<asp:DropDownList ID="ddlInst" runat="server">
					</asp:DropDownList>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Language (MARC 008):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:DropDownList ID="ddlLang" runat="server">
					</asp:DropDownList>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Description:
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="descTextBox" runat="server" MaxLength="8000" Width="100%" TextMode="MultiLine" Height="50px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Publication Place (MARC 260a):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="publicationPlaceTextBox" runat="server" MaxLength="150" Width="100%"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Publisher Name (MARC 260b):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="publisherNameTextBox" runat="server" MaxLength="255" Width="100%"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Publication Date (MARC 260c):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="publicationDateTextBox" runat="server" MaxLength="100" Width="100%"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" class="dataHeader">
					Start Year (MARC 008 char8-11):
				</td>
				<td>
					<asp:TextBox ID="startYearTextBox" runat="server"></asp:TextBox>
				</td>
				<td style="white-space: nowrap" align="right" class="dataHeader">
					End Year (MARC 008 char12-15):
				</td>
				<td>
					<asp:TextBox ID="endYearTextBox" runat="server"></asp:TextBox>
				</td>
				<td width="100%">
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Original Cataloging Source (MARC 040a):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="OrigCatalogSourceTextBox" runat="server" MaxLength="100" Width="400px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Edition Statement (MARC 250a,b):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="EditionStatementTextBox" runat="server" MaxLength="450" Width="100%"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Publication Frequency (MARC 310a):
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="PubFrequencyTextBox" runat="server" MaxLength="100" Width="400px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td style="white-space: nowrap" align="right" valign="top" class="dataHeader">
					Notes:
				</td>
				<td colspan="4" style="width: 100%">
					<asp:TextBox ID="notesTextBox" runat="server" MaxLength="255" Width="100%"></asp:TextBox>
				</td>
			</tr>
		</table>
		<fieldset>
			<legend class="dataHeader">Creators (MARC 1XX and 70X-75X)</legend>
			<asp:GridView ID="creatorsList" runat="server" AutoGenerateColumns="False" CellPadding="5" GridLines="None" 
			AlternatingRowStyle-BackColor="#F7FAFB" RowStyle-BackColor="white"
				Width="800px" CssClass="boxTable" OnRowCancelingEdit="creatorsList_RowCancelingEdit" OnRowEditing="creatorsList_RowEditing"
				OnRowUpdating="creatorsList_RowUpdating" OnRowCommand="creatorsList_RowCommand" DataKeyNames="Title_CreatorID,CreatorID,CreatorRoleTypeID">
				<Columns>
					<asp:ButtonField ButtonType="Link" Text="Remove" CommandName="RemoveButton" ItemStyle-Width="50px" />
					<asp:TemplateField HeaderText="Name" ItemStyle-Width="350px">
						<ItemTemplate>
							<%# Eval( "CreatorName" ) %>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:DropDownList ID="ddlCreatorName" runat="server" DataTextField="CreatorName" DataValueField="CreatorID" DataSource="<%# GetCreators() %>"
								SelectedIndex="<%# GetCreatorIndex( Container.DataItem ) %>" Width="400px" />
						</EditItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Role" ItemStyle-Width="270px">
						<ItemTemplate>
							<%# Eval( "CreatorRoleTypeDescription" ) %>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:DropDownList ID="ddlCreatorRole" runat="server" DataTextField="CreatorRoleTypeDescription" DataValueField="CreatorRoleTypeID"
								DataSource="<%# GetCreatorRoles() %>" SelectedIndex="<%# GetCreatorRoleIndex( Container.DataItem ) %>" />
						</EditItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="130px">
						<ItemTemplate>
							<asp:LinkButton ID="editTitleCreatorButton" runat="server" CommandName="Edit" Text="Edit"></asp:LinkButton>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:LinkButton ID="updateTitleCreatorButton" runat="server" CommandName="Update" Text="Update"></asp:LinkButton>
							<asp:LinkButton ID="cancelTitleCreatorButton" runat="server" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
						</EditItemTemplate>
					</asp:TemplateField>
				</Columns>
				<HeaderStyle HorizontalAlign="Left" CssClass="SearchResultsHeader" />
			</asp:GridView>
			<br />
			<asp:Button ID="addCreatorButton" runat="server" Text="Add Creator" OnClick="addCreatorButton_Click" />
		</fieldset>
		<br />
		<fieldset>
		    <legend class="dataHeader">Subjects (MARC 6XX)</legend>
			<asp:GridView ID="subjectsList" runat="server" AutoGenerateColumns="False" CellPadding="5" GridLines="None" 
			AlternatingRowStyle-BackColor="#F7FAFB" RowStyle-BackColor="white"
				Width="800px" CssClass="boxTable" OnRowCancelingEdit="subjectsList_RowCancelingEdit" OnRowEditing="subjectsList_RowEditing"
				OnRowUpdating="subjectsList_RowUpdating" OnRowCommand="subjectsList_RowCommand" DataKeyNames="TitleID, TagText">
				<Columns>
					<asp:ButtonField ButtonType="Link" Text="Remove" CommandName="RemoveButton" ItemStyle-Width="50px" />
					<asp:TemplateField HeaderText="Subject" ItemStyle-Width="220px">
						<ItemTemplate>
							<%# Eval( "TagText" ) %>
						</ItemTemplate>
						<EditItemTemplate>
						    <asp:TextBox ID="txtTagText" runat="server" Text='<%# Eval( "TagText") %>' />
						</EditItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="MARC Data Field" ItemStyle-Width="220px">
						<ItemTemplate>
							<%# Eval( "MarcDataFieldTag" ) %>
						</ItemTemplate>
						<EditItemTemplate>
						    <asp:TextBox ID="txtMarcDataFieldTag" runat="server" Text='<%# Eval( "MarcDataFieldTag") %>' />
						</EditItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="MARC Code" ItemStyle-Width="220px">
						<ItemTemplate>
							<%# Eval( "MarcSubFieldCode" ) %>
						</ItemTemplate>
						<EditItemTemplate>
						    <asp:TextBox ID="txtMarcSubFieldCode" runat="server" Text='<%# Eval( "MarcSubFieldCode") %>' />
						</EditItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="130px">
						<ItemTemplate>
							<asp:LinkButton ID="editSubjectCreatorButton" runat="server" CommandName="Edit" Text="Edit"></asp:LinkButton>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:LinkButton ID="updateSubjectCreatorButton" runat="server" CommandName="Update" Text="Update"></asp:LinkButton>
							<asp:LinkButton ID="cancelSubjectCreatorButton" runat="server" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
						</EditItemTemplate>
					</asp:TemplateField>
				</Columns>
				<HeaderStyle HorizontalAlign="Left" CssClass="SearchResultsHeader" />
			</asp:GridView>
			<br />
			<asp:Button ID="addSubjectButton" runat="server" Text="Add Subject" OnClick="addSubjectButton_Click" />
		</fieldset>
		<br />
		<fieldset>
			<legend class="dataHeader">Title Identifiers (various MARC fields)</legend>
			<asp:GridView ID="identifiersList" runat="server" AutoGenerateColumns="False" CellPadding="5" GridLines="None" 
			AlternatingRowStyle-BackColor="#F7FAFB" RowStyle-BackColor="white"
				Width="800px" CssClass="boxTable" OnRowCancelingEdit="identifiersList_RowCancelingEdit" OnRowEditing="identifiersList_RowEditing"
				OnRowUpdating="identifiersList_RowUpdating" OnRowCommand="identifiersList_RowCommand" DataKeyNames="Title_TitleIdentifierID, TitleIdentifierID, IdentifierValue">
				<Columns>
					<asp:ButtonField ButtonType="Link" Text="Remove" CommandName="RemoveButton" ItemStyle-Width="50px" />
					<asp:TemplateField HeaderText="Identifier" ItemStyle-Width="400px">
						<ItemTemplate>
							<%# Eval( "IdentifierNameFull" ) %>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:DropDownList ID="ddlIdentifierName" runat="server" DataTextField="IdentifierNameFull" DataValueField="TitleIdentifierID" 
							    DataSource="<%# GetTitleIdentifiers() %>" SelectedIndex="<%# GetTitleIdentifierIndex( Container.DataItem ) %>" Width="400px" />
						</EditItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Value" ItemStyle-Width="220px">
						<ItemTemplate>
							<%# Eval( "IdentifierValue" ) %>
						</ItemTemplate>
						<EditItemTemplate>
						    <asp:TextBox ID="txtIdentifierValue" runat="server" Text='<%# Eval( "IdentifierValue") %>' />
						</EditItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="130px">
						<ItemTemplate>
							<asp:LinkButton ID="editTitleIdentifierButton" runat="server" CommandName="Edit" Text="Edit"></asp:LinkButton>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:LinkButton ID="updateTitleIdentifierButton" runat="server" CommandName="Update" Text="Update"></asp:LinkButton>
							<asp:LinkButton ID="cancelTitleIdentifierButton" runat="server" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
						</EditItemTemplate>
					</asp:TemplateField>
				</Columns>
				<HeaderStyle HorizontalAlign="Left" CssClass="SearchResultsHeader" />
			</asp:GridView>
			<br />
			<asp:Button ID="addTitleIdentifierButton" runat="server" Text="Add Title Identifier" OnClick="addTitleIdentifierButton_Click" />
		</fieldset>
		<br />
		<fieldset>
			<legend class="dataHeader">Languages (MARC 041)</legend>
			<asp:GridView ID="languagesList" runat="server" AutoGenerateColumns="False" CellPadding="5" GridLines="None" AlternatingRowStyle-BackColor="#F7FAFB"
				RowStyle-BackColor="white" Width="400px" CssClass="boxTable" OnRowCancelingEdit="languagesList_RowCancelingEdit" OnRowEditing="languagesList_RowEditing"
				OnRowUpdating="languagesList_RowUpdating" OnRowCommand="languagesList_RowCommand" DataKeyNames="TitleLanguageID,LanguageCode">
				<Columns>
					<asp:ButtonField ButtonType="Link" Text="Remove" CommandName="RemoveButton" ItemStyle-Width="50px" />
					<asp:TemplateField HeaderText="Language Code" ItemStyle-Width="200px">
						<ItemTemplate>
							<%# Eval( "LanguageName" ) %>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:DropDownList ID="ddlLanguageName" runat="server" DataTextField="LanguageName" DataValueField="LanguageCode" DataSource="<%# GetLanguages() %>"
								SelectedIndex="<%# GetLanguageIndex( Container.DataItem ) %>" Width="200px" />
						</EditItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="130px">
						<ItemTemplate>
							<asp:LinkButton ID="editLanguageButton" runat="server" CommandName="Edit" Text="Edit"></asp:LinkButton>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:LinkButton ID="updateLanguageButton" runat="server" CommandName="Update" Text="Update"></asp:LinkButton>
							<asp:LinkButton ID="cancelLanguageButton" runat="server" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
						</EditItemTemplate>
					</asp:TemplateField>
				</Columns>
				<HeaderStyle HorizontalAlign="Left" CssClass="SearchResultsHeader" />
			</asp:GridView>
			<br />
			<asp:Button ID="addLanguageButton" runat="server" Text="Add Language" OnClick="addLanguageButton_Click" />
		</fieldset>
		<br />
		<fieldset>
			<legend class="dataHeader">Title Associations (MARC 440, 490, 78X, 830, and 773)</legend>
			<asp:GridView ID="associationsList" runat="server" AutoGenerateColumns="False" CellPadding="5" GridLines="None" 
			AlternatingRowStyle-BackColor="#F7FAFB" RowStyle-BackColor="white" Width="800px" CssClass="boxTable" 
				OnRowCommand="associationsList_RowCommand" DataKeyNames="TitleAssociationID">
				<Columns>
					<asp:ButtonField ButtonType="Link" Text="Remove" CommandName="RemoveButton" ItemStyle-Width="50px" />
					<asp:TemplateField HeaderText="Type" ItemStyle-Width="200px">
						<ItemTemplate>
							<%# Eval( "TitleAssociationName" ) %>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Title" ItemStyle-Width="400px">
						<ItemTemplate>
							<%# Eval( "Title" ) %>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Title ID" ItemStyle-Width="100px">
					    <ItemTemplate>
					        <%# Eval("AssociatedTitleID") %>
					    </ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="130px">
						<ItemTemplate>
						    <span style="text-decoration:underline;color:#a54219;" onclick="document.getElementById('titleAssociationEditLayer').style.display='block';document.getElementById('titleAssociationEditFrame').src='TitleAssociationEdit.aspx?id=<%# Eval("TitleAssociationID") %>&tid=<%# Eval("TitleID") %>';">View/Edit Details</span>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<HeaderStyle HorizontalAlign="Left" CssClass="SearchResultsHeader" />
			</asp:GridView>
			<br />
			<input type="button" onclick="document.getElementById('titleAssociationEditLayer').style.display='block';document.getElementById('titleAssociationEditFrame').src='TitleAssociationEdit.aspx?id=0&tid={0}&type=new';" id="btnTitleAssociationAdd" runat="server" value="Add Title Association" />
		</fieldset>
		<br />
		<fieldset>
			<legend class="dataHeader">Title Types</legend>
			<asp:GridView ID="titleTypesList" runat="server" AutoGenerateColumns="False" CellPadding="5" GridLines="None" AlternatingRowStyle-BackColor="#F7FAFB"
				RowStyle-BackColor="white" Width="400px" CssClass="boxTable" OnRowCancelingEdit="titleTypesList_RowCancelingEdit" OnRowEditing="titleTypesList_RowEditing"
				OnRowUpdating="titleTypesList_RowUpdating" OnRowCommand="titleTypesList_RowCommand" DataKeyNames="Title_TitleTypeID,TitleTypeID">
				<Columns>
					<asp:ButtonField ButtonType="Link" Text="Remove" CommandName="RemoveButton" ItemStyle-Width="50px" />
					<asp:TemplateField HeaderText="Title Type" ItemStyle-Width="200px">
						<ItemTemplate>
							<%# Eval( "TitleType" ) %>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:DropDownList ID="ddlTitleType" runat="server" DataTextField="TitleType" DataValueField="TitleTypeID" DataSource="<%# GetTitleTypes() %>"
								SelectedIndex="<%# GetTitleTypeIndex( Container.DataItem ) %>" Width="200px" />
						</EditItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="130px">
						<ItemTemplate>
							<asp:LinkButton ID="editTitleTypeButton" runat="server" CommandName="Edit" Text="Edit"></asp:LinkButton>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:LinkButton ID="updateTitleTypeButton" runat="server" CommandName="Update" Text="Update"></asp:LinkButton>
							<asp:LinkButton ID="cancelTitleTypeButton" runat="server" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
						</EditItemTemplate>
					</asp:TemplateField>
				</Columns>
				<HeaderStyle HorizontalAlign="Left" CssClass="SearchResultsHeader" />
			</asp:GridView>
			<br />
			<asp:Button ID="addTitleTypeButton" runat="server" Text="Add Title Type" OnClick="addTitleTypeButton_Click" />
		</fieldset>
		<br />
		Item status filter: <asp:RadioButton ID="showAllRadioButton" runat="server" GroupName="filterItemGroup" Checked="false" AutoPostBack="true" Text="Show all" OnCheckedChanged="itemFilter_CheckedChanged" />
		<asp:RadioButton ID="showPubRadioButton" runat="server" GroupName="filterItemGroup" AutoPostBack="true" Checked="true" Text="Show only published" OnCheckedChanged="itemFilter_CheckedChanged" />
		<fieldset>
			<legend class="dataHeader">Title Items</legend>
			<asp:GridView ID="itemsList" runat="server" AutoGenerateColumns="False" CellPadding="5" GridLines="None" AllowSorting="true" AlternatingRowStyle-BackColor="#F7FAFB"
				RowStyle-BackColor="white" Width="800px" CssClass="boxTable" OnRowCancelingEdit="itemsList_RowCancelingEdit" OnRowEditing="itemsList_RowEditing" OnRowUpdating="itemsList_RowUpdating"
				OnRowCommand="itemsList_RowCommand" OnSorting="itemsList_Sorting" OnRowDataBound="itemsList_RowDataBound" DataKeyNames="ItemID">
				<Columns>
					<asp:ButtonField ButtonType="Link" Text="Remove" CommandName="RemoveButton" ItemStyle-Width="50px" />
					<asp:BoundField DataField="ItemID" HeaderText="Item ID" SortExpression="ItemID" ItemStyle-Width="80px" ReadOnly="true" />
					<asp:HyperLinkField HeaderText="Barcode" DataNavigateUrlFields="ItemID" DataNavigateUrlFormatString="/Admin/ItemEdit.aspx?id={0}"
						DataTextField="BarCode" NavigateUrl="/Admin/ItemEdit.aspx" SortExpression="BarCode" />
					<asp:TemplateField HeaderText="Sequence" ItemStyle-Width="80px" SortExpression="ItemSequence">
						<ItemTemplate>
							<%# Eval( "ItemSequence" ) %>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:TextBox ID="itemSequenceTextBox" runat="server" Width="80px" Text='<%# Eval( "ItemSequence" ) %>' />
						</EditItemTemplate>
					</asp:TemplateField>
					<asp:BoundField DataField="Volume" HeaderText="Volume" SortExpression="Volume" ReadOnly="true" />
					<asp:TemplateField HeaderText="Is Primary" ItemStyle-Width="70px">
						<ItemTemplate>
						    <asp:CheckBox ID="isPrimaryCheckBox" Enabled=false Checked='<%#(Convert.ToInt32(Eval("PrimaryTitleID")) == Convert.ToInt32(Eval("TitleID")))%>' runat="server" />
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="130px">
						<ItemTemplate>
							<asp:LinkButton ID="editItemButton" runat="server" CommandName="Edit" Text="Edit Sequence"></asp:LinkButton>
						</ItemTemplate>
						<EditItemTemplate>
							<asp:LinkButton ID="updateItemButton" runat="server" CommandName="Update" Text="Update"></asp:LinkButton>
							<asp:LinkButton ID="cancelItemButton" runat="server" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
						</EditItemTemplate>
					</asp:TemplateField>
				</Columns>
				<HeaderStyle HorizontalAlign="Left" CssClass="SearchResultsHeader" />
			</asp:GridView>
			<input type="button" onclick="overlay();document.getElementById('srchTitleID').focus();" id="btnAddItem" value="Add Item" />
		</fieldset>
		<br />
		<asp:Button ID="saveButton" runat="server" OnClick="saveButton_Click" Text="Save" />
	</div>
	<div id="overlayitem">
	    <div>
	        <table cellpadding="3" class="SearchText">
	            <tr>
	                <td colspan="5" align="left">
	                    <b>Search for a title containing the items you would like to add.</b>
	                </td>
	            </tr>
	            <tr>
	                <td style="white-space: nowrap">Title ID:</td>
	                <td><input id="srchTitleID" type="text" class="SearchText" onkeydown="keyDownHandler(event, btnItemSearch);" /></td>
	                <td style="white-space: nowrap">Full Title:</td>
	                <td><input id="srchTitle" type="text" class="SearchText" onkeydown="keyDownHandler(event, btnItemSearch);" /></td>
	                <td><input id="btnItemSearch" type="button" onclick="titleSearch(document.getElementById('srchTitleID').value, document.getElementById('srchTitle').value);" value="Search" class="SearchText" /></td>
	            </tr>
	            <tr>
	                <td colspan="5">
	                    <table id="srchTitleTable" style="display:none" cellpadding="3" cellspacing="3" width="100%">
	                      <tbody>
	                        <tr>
	                            <td colspan="2" align="left">
	                                <b>Click a title to view and select individual items.</b>
	                            </td>
	                        </tr>
	                        <tr class="SearchResultsHeader" align="left">
	                            <th scope="col">Title&nbsp;ID</th>
	                            <th scope="col">Title</th>
	                        </tr>
	                      </tbody>
	                    </table>
	                    <table id="srchResultTable" style="display:none" cellpadding="3" cellspacing="3" width="100%">
	                      <tbody>
	                        <tr>
	                            <td colspan="4" align="left">
	                                <b>Check the box next to the items you want to add to the title.</b><br />
	                                <asp:CheckBox runat="server" ID="makePrimary" Checked="true" />
	                            </td>
	                        </tr>
	                        <tr class="SearchResultsHeader" align="left">
	                            <th scope="col">Item&nbsp;ID</th>
	                            <th scope="col">Barcode</th>
	                            <th scope="col">Volume</th>
	                            <th>&nbsp;</th>
	                        </tr>
	                      </tbody>
	                    </table>
        	        </td>
	            </tr>
	        </table>
	        <a id="hypDone" href="#" onclick="addItemsToTitle();">Done</a>&nbsp;&nbsp;
	        <a id="hypCancel" href="#" onclick="clearItems('');">Cancel</a>
	        <input type="hidden" id="selectedItem" value="" runat="server" />
	        <input type="hidden" id="associationsUpdated" value="" runat="server" />
	    </div>	
	</div>
	<div id="titleAssociationEditLayer" style="width:700px;height:515px;border:1px solid #000000;background-color:#FFFFFF;padding:0px;position:absolute;top:1035px;left:50px;z-index:1000;display:none">
	    <iframe id="titleAssociationEditFrame" src="" style="width:100%;height:100%;"></iframe>
	</div>
	<script language="javascript">
	    function addItemsToTitle() {
	        var checkboxes; var x = 0;

	        checkboxes = document.getElementsByName('makePrimaryCheckbox');
	        for (x = 0; x < checkboxes.length; x++) {
	            if (checkboxes[x].checked) selectItem(checkboxes[x].value);
	        }

	        overlay(); __doPostBack('', '');
	    }
    </script>
</asp:Content>
