using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Data;
using System.Text;
using System.Collections.ObjectModel;

public partial class _Default : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        lblTitle.ToolTip = System.Environment.MachineName;
        RefreshProgress();
    }

    DataView getMoveStatus()
    {
        string scriptpath = "& " + Server.MapPath(".\\Get-MoveRequestProgressData.ps1");
        if (!chkShowComplete.Checked) { scriptpath += " -HideComplete"; }
        if (!chkShowSuspended.Checked) { scriptpath += " -HideSuspended"; }
        Collection<DataTable> mr = PowerShell.Create().AddScript(scriptpath).Invoke<DataTable>();
        //lblTest.Text = mr.Count.ToString();
        if (mr.Count == 1)
        {
            DataView dv = mr[0].DefaultView;
            string _sort = "";
            string _dir = " ASC";
            if (chkSortDesc.Checked) { _dir = " DESC"; }
            if (rbName.Checked) { _sort = "Username" + _dir; }
            if (rbProgress.Checked) { _sort = "Progress" + _dir + ", Username" + _dir; }
            if (rbStatus.Checked) { _sort = "Status" + _dir + ", Progress" + _dir + ", Username" + _dir; }
            dv.Sort = _sort;
            dlProg.RepeatColumns = Convert.ToInt32(txtCols.Text);
            lblCount.Text = dv.Count.ToString() + " mailboxes";

            if (!chkShowComplete.Checked)
            {
                //dv.RowFilter = "Status <> 'Completed'";
            }
            return dv;
        }
        else { return null; }
    }

    void RefreshProgress()
    {
        dlProg.DataSource = getMoveStatus();
        dlProg.DataBind();
        lblUpdated.Text = "Last updated: " + DateTime.Now.ToString();
        Timer1.Interval = Convert.ToInt32(txtRefreshRate.Text) * 1000;
    }

    protected void Timer1_Tick(object sender, EventArgs e)
    {
        RefreshProgress();
    }

    protected void chkShowComplete_CheckChanged(object sender, EventArgs e)
    {
        RefreshProgress();
    }

    //Pipeline GetPipeline() 
    //{
    //    RunspaceConfiguration rconfig = RunspaceConfiguration.Create();
    //    PSSnapInException Pwarn = new PSSnapInException();

    //    rconfig.AddPSSnapIn("Microsoft.Exchange.Management.PowerShell.E2010", out Pwarn);
    //    Runspace runspace = RunspaceFactory.CreateRunspace(rconfig);
    //    runspace.Open();
    //    Pipeline pipeline = runspace.CreatePipeline();

    //    return pipeline;
    //}

    protected void btnApply_Click(object sender, EventArgs e)
    {
        RefreshProgress();
    }
    protected void dlProg_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        Image imgProgress = (Image)e.Item.FindControl("imgProgress");
        if (DataBinder.Eval(e.Item.DataItem, "Progress") != DBNull.Value)
        {
            int prog = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "Progress"));
            string status = (string)DataBinder.Eval(e.Item.DataItem, "Status");
            if (prog < 100)
            {
                imgProgress.ImageUrl = "./images/yellow.png";
            }
            else
            {
                imgProgress.ImageUrl = "./images/green.png";
            }
            if (status.Contains("Suspended") || status == "CompletedWithWarning")
            {
                imgProgress.ImageUrl = "./images/orange.png";
            }
            if (status == "Failed")
            {
                imgProgress.ImageUrl = "./images/red.png";
            }
        }
    }
}