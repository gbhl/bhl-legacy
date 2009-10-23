using System;
using System.Data;
using System.Configuration;
using System.Collections;
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

namespace MOBOT.BHL.Web.Admin
{
    public partial class LocationEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillLocations();
            }
            errorControl.Visible = false;
        }

        private void fillLocations()
        {
            BHLProvider bp = new BHLProvider();
            CustomGenericList<Location> locations = bp.LocationSelectAll();

            Location emptyLocation = new Location();
            emptyLocation.LocationName = String.Empty;
            emptyLocation.Latitude = String.Empty;
            emptyLocation.Longitude = String.Empty;
            emptyLocation.NextAttemptDate = DateTime.Now;
            emptyLocation.IncludeInUI = true;

            locations.Insert(0, emptyLocation);

            ddlLocations.DataSource = locations;
            ddlLocations.DataTextField = "LocationName";
            ddlLocations.DataValueField = "LocationName";
            ddlLocations.DataBind();
        }

        private void clearForm(ControlCollection controls)
        {
            foreach (Control c in controls)
            {
                if (c is TextBox)
                {
                    TextBox textBox = (TextBox)c;
                    textBox.Text = "";
                }
                else if (c.HasControls())
                {
                    clearForm(c.Controls);
                }
            }
        }

        private bool validate()
        {
            bool flag = false;
            if (latitudeTextBox.Text.Trim().Length == 0)
            {
                flag = true;
                errorControl.AddErrorText("Latitude is missing");
            }

            if (longitudeTextBox.Text.Trim().Length == 0)
            {
                flag = true;
                errorControl.AddErrorText("Longitude is missing");
            }

            errorControl.Visible = flag;

            return !flag;
        }

        #region Event handlers

        protected void saveButton_Click(object sender, EventArgs e)
        {
            if (validate())
            {
                if (hidCode.Value.Length == 0)
                {
                    errorControl.AddErrorText("Please select a location before saving");
                    errorControl.Visible = true;
                    return;
                }

                Location location = new Location();
                location.LocationName = hidCode.Value;
                location.Latitude = (latitudeTextBox.Text.Trim() == String.Empty) ? null : latitudeTextBox.Text.Trim();
                location.Longitude = (longitudeTextBox.Text.Trim() == String.Empty) ? null : longitudeTextBox.Text.Trim();
                if (location.Latitude != null || longitudeTextBox != null)
                {
                    location.NextAttemptDate = null;
                }
                else
                {
                    location.NextAttemptDate = (nextAttemptLiteral.Text == String.Empty ? location.NextAttemptDate : Convert.ToDateTime(nextAttemptLiteral.Text));
                }
                location.IncludeInUI = includeInUICheckbox.Checked;
                location.LastModifiedDate = DateTime.Now;

                location.IsNew = false;

                BHLProvider bp = new BHLProvider();
                bp.SaveLocation(location);
            }
            else
            {
                return;
            }

            Response.Redirect("/Admin/LocationEdit.aspx");
        }

        protected void clearButton_Click(object sender, EventArgs e)
        {
            clearForm(this.Controls);
        }

        protected void ddlLocations_SelectedIndexChanged(object sender, EventArgs e)
        {
            clearForm(this.Controls);
            string name = ddlLocations.SelectedValue;
            if (name.Length > 0)
            {
                BHLProvider bp = new BHLProvider();
                Location location = bp.LocationSelectAuto(name);
                if (location != null)
                {
                    divAltLocations.Visible = true;

                    nameLiteral.Text = location.LocationName;
                    hidCode.Value = location.LocationName;
                    latitudeTextBox.Text = location.Latitude;
                    longitudeTextBox.Text = location.Longitude;
                    nextAttemptLiteral.Text = location.NextAttemptDate.ToString();
                    includeInUICheckbox.Checked = location.IncludeInUI;

                    ddlLocations.SelectedValue = location.LocationName;
                }
            }
            else
            {
                divAltLocations.Visible = false;
            }
        }

        #endregion
    }
}
