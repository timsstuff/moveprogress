<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 200px; border:1px solid black; display: inline-block; text-align: left">
            <asp:Image ID="imgProgress" runat="server" Height="20px" ImageUrl="images/red.png" Width="50px" style="margin-bottom: -4px" />
            <div style="position: absolute; margin-top: -18px; margin-left: 5px"><asp:Label ID="lblStatus" runat="server" Text="InProgress" /></div>
        </div>
    </form>
</body>
</html>
