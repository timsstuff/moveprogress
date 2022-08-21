<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" Trace="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mailbox Move Progress</title>
    <style>
        body, td {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 9pt;
        }

        h1, .h1 {
            font-size: 14pt;
            font-weight: bold;
            color: #073A65;
        }

        h2, .h2 {
            font-size: 12pt;
            font-weight: bold;
            color: #073A65;
        }

        h3, .h3 {
            font-size: 10pt;
            font-weight: bold;
            color: #073A65;
        }

        th, .th {
            background-color: #073A65;
            vertical-align: top;
            color: white;
            font-weight: bold;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 12px;
            padding: 5px;
            white-space: nowrap;
        }
        #rbProgress {vertical-align: middle}
        #rbName {vertical-align: middle}
        #rbStatus {vertical-align: middle}
        #chkSortDesc {vertical-align: middle}
        label  {vertical-align: middle}
        input  {vertical-align: middle; text-align: center; font-size: 8pt}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="360000" />
        <asp:UpdateProgress runat="server" ID="up1" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div style="margin: auto; text-align: center; font-size: 24pt; font-weight: bold; color: #909090;
                    text-shadow: 4px 4px 4px blue; -moz-text-shadow: 4px 4px 4px blue; -webkit-text-shadow: 4px 4px 4px blue;
                    width: 100%; height: 100%; position: absolute; top: 0px; left: 0px; background-color: black; 
                    opacity: 0.5; filter:alpha(opacity=50);">
                    <div style="margin-top: 10%; color: white">Please Wait...</div>
                </div>
                <a href="" id="lnkClick">
                    <img src="images/spinner.gif" style="position: absolute; top: 50%; left: 50%; transform: translateY(-50%) translateX(-50%); " />
                </a>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <h1 style="text-align: center"><asp:Label id="lblTitle" runat="server">Mailbox Move Progress</asp:Label></h1>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">            
            <ContentTemplate>
                <table align="center">
                    <tr>
                        <td style="text-align: right">Columns:</td>
                        <td><asp:TextBox ID="txtCols" runat="server" Width="25px" Text="3" /></td>
                        <td style="text-align: right">Sort:</td>
                        <td nowrap>
                            <asp:RadioButton ID="rbProgress" runat="server" GroupName="Sort" Text="Progress" AutoPostBack="False" />
                            <asp:RadioButton ID="rbName" runat="server" GroupName="Sort" Text="Name" />
                            <asp:RadioButton ID="rbStatus" runat="server" GroupName="Sort" Text="Status" CausesValidation="False" AutoPostBack="False" Checked="True" />
                            <asp:CheckBox ID="chkSortDesc" runat="server" Text="Desc" AutoPostBack="False" Checked="True" />
                        </td>
                        <td><asp:Button ID="btnApply" runat="server" Text="Go" OnClick="btnApply_Click" /></td>
                    </tr>
                </table>
                <asp:DataList ID="dlProg" runat="server" HorizontalAlign="Center" RepeatColumns="3" ItemStyle-Wrap="False" OnItemDataBound="dlProg_ItemDataBound">
                    <ItemTemplate>
                        <div style="width: 200px; overflow-x: hidden; display: inline-block; text-align: right; font-size: 8pt">
                            <asp:Label runat="server" ID="lblUsername" Text='<%# Eval("Username") %>' />
                        </div>
                        <div style="width: 301px; border:1px solid black; display: inline-block; z-index: 1; font-size: 8pt">
                            <asp:Image ID="imgProgress" runat="server" Height="20px" Width='<%#(Eval("Progress") != DBNull.Value)?Convert.ToInt32(Eval("Progress")) * 3:0 %>' 
                                style="margin-bottom: -3px; border-right: 1px solid #d0d0d0; z-index: -10" />
                            <div style="position: absolute; margin-top: -16px; margin-left: 5px"><asp:Label ID="lblStatus" runat="server" 
                                Text='<%# String.Format("{0} ({1})", Eval("Status"), Eval("Detail")) %>' />
                            </div>
                            <div style="position: absolute; margin-top: -16px; margin-left: 198px; text-align: right; width: 100px">
                                <asp:Label ID="lblPct" runat="server" Text='<%# Eval("Progress") + "% (" + Eval("Bytes") + " MB)" %>' />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:DataList>
                <asp:Timer ID="Timer1" runat="server" Interval="60000" OnTick="Timer1_Tick"></asp:Timer>
                <div style="text-align: center; font-size: 8pt">
                    <asp:Label runat="server" ID="lblCount" Style="font-size: 8pt" />
                    <asp:Label ID="lblUpdated" runat="server" Text="Last updated: " Style="font-size: 8pt" />
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Default.aspx" Style="font-size: 8pt">Refresh</asp:HyperLink>
                    Every:<asp:TextBox ID="txtRefreshRate" runat="server" Text="60" Width="25px" />sec
                    <asp:CheckBox ID="chkShowComplete" runat="server" AutoPostBack="False" Checked="False" Font-Size="8pt" Text="Show Completed" OnCheckedChanged="chkShowComplete_CheckChanged" />
                    <asp:CheckBox ID="chkShowSuspended" runat="server" AutoPostBack="False" Checked="True" Font-Size="8pt" Text="Show Suspended" OnCheckedChanged="chkShowComplete_CheckChanged" />
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:Label runat="server" ID="lblTest" />
        <asp:TextBox ID="txtTest" runat="server" Height="291px" TextMode="MultiLine" Width="494px" Visible="false" />
    </form>
</body>
</html>
