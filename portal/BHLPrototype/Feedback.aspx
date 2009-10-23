<%@ Page Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" Codebehind="Feedback.aspx.cs" Inherits="MOBOT.BHL.Web.Feedback" %>

<%@ Register TagPrefix="cc" Namespace="MOBOT.BHL.Web" Assembly="MOBOT.BHL.Web" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="mainContentPlaceHolder" runat="server">
	<cc:ContentPanel ID="feedbackContentPanel" runat="server">
		<div class="BlackHeading">
			Web Site Feedback
		</div>
		<br />
		<table cellpadding="3">
			<tr>
				<td align="right">
					Name:
				</td>
				<td>
					<asp:TextBox ID="nameTextBox" runat="server" Width="200px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td align="right">
					Email:
				</td>
				<td>
					<asp:TextBox ID="emailTextBox" runat="server" Width="200px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td align="right">
					Subject:
					<asp:RequiredFieldValidator ID="subjectValidator" runat="server" ControlToValidate="rbList" ErrorMessage="Please choose a subject">*</asp:RequiredFieldValidator></td>
				<td style="height: 23px">
					<asp:RadioButtonList runat="server" ID="rbList" RepeatDirection="Horizontal">
						<asp:ListItem Text="Technical Issues" Value="1"></asp:ListItem>
						<asp:ListItem Text="Suggestion" Value="5"></asp:ListItem>
						<asp:ListItem Text="Bibliographic Issues" Value="6"></asp:ListItem>
					</asp:RadioButtonList>
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					Comment:
					<asp:RequiredFieldValidator ID="commentValidator" runat="server" ControlToValidate="commentTextBox" ErrorMessage="Please supply a comment">*</asp:RequiredFieldValidator>
				</td>
				<td>
					<asp:TextBox ID="commentTextBox" runat="server" Height="100px" Width="400px" TextMode="MultiLine"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td>
				</td>
				<td>
					&nbsp;
					<asp:Button ID="submitButton" runat="server" Text="Submit" OnClick="submitButton_Click" />
					&nbsp;
					<asp:Button ID="closeButton" runat="server" Text="Close" OnClick="closeButton_Click" CausesValidation="false" />
				</td>
			</tr>
		</table>
		<br />
		<asp:ValidationSummary ID="validationSummary" runat="server" />
		<asp:Panel ID="errorPanel" runat="server" Visible="false">
			<br />
			<asp:Label ID="errorLabel" runat="server" ForeColor="red" Text="Label"></asp:Label>
		</asp:Panel>
	</cc:ContentPanel>
</asp:Content>
