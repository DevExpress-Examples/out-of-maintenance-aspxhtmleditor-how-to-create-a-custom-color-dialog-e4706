<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="DXWebApplication1.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Custom Color Picker</title>
    <link href="css/bootstrap-colorpicker.css" rel="stylesheet" />

    <script src="js/jquery-3.1.0.js"></script>
    <script src="js/bootstrap-colorpicker.js"></script>

    <style>
        .image-custombackcolor {
            height: 14px;
            width: 14px;
            background-color: white;
        }

        .image-customforecolor {
            height: 14px;
            width: 14px;
            background-color: black;
        }
    </style>
    <script>
        function onInit(htmlEditor) {
            htmlEditor.CustomCommand.AddHandler(onCustomCommand);
            htmlEditor.SelectionChanged.AddHandler(onSelectionChanged);
        }
        function onCustomCommand(htmlEditor, args) {
            if(args.commandName == "custombackcolor" || args.commandName == "customforecolor") {
                var element = document.querySelector(".image-" + args.commandName);
                colorPickerPopup.ShowAtElement(element);
                colorPickerPopup.customCommand = args.commandName == "custombackcolor" ? ASPxClientCommandConsts.BACKCOLOR_COMMAND : ASPxClientCommandConsts.FONTCOLOR_COMMAND;
                $('#colorpicker').colorpicker({
                    color: ASPx.Color.ColorToHexadecimal(element.style.backgroundColor),
                    container: true,
                    inline: true
                });
            }
        }
        function onColorApply() {
            var value = $('#colorpicker').colorpicker('getValue');
            switch(colorPickerPopup.customCommand) {
                case ASPxClientCommandConsts.BACKCOLOR_COMMAND:
                    updateCustomBackColor(value);
                    break;
                case ASPxClientCommandConsts.FONTCOLOR_COMMAND:
                    updateCustomForeColor(value);
                    break;
            }
            htmlEditor.ExecuteCommand(colorPickerPopup.customCommand, value);
            colorPickerPopup.customCommand = null;
            colorPickerPopup.Hide();
        }
        function onSelectionChanged(htmlEditor) {
            var selectedElement = htmlEditor.GetSelection().GetSelectedElement();
            if(selectedElement) {
                updateCustomBackColor(ASPx.Color.ColorToHexadecimal(selectedElement.style.backgroundColor || "#FFFFFF"));
                updateCustomForeColor(ASPx.Color.ColorToHexadecimal(selectedElement.style.color || selectedElement.color || "#000000"));
            }
        }
        function updateCustomForeColor(color) {
            document.querySelector(".image-customforecolor").style.backgroundColor = color;
        }
        function updateCustomBackColor(color) {
            document.querySelector(".image-custombackcolor").style.backgroundColor = color;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <p>
                The BOOTSTRAP-COLORPICKER library is licensed under the Apache License. Refer to the <a href="https://github.com/itsjavi/bootstrap-colorpicker/blob/master/LICENSE">https://github.com/itsjavi/bootstrap-colorpicker/blob/master/LICENSE </a> page for more information.
            </p>
            <dx:ASPxPopupControl runat="server" ID="colorPickerPopup" ClientInstanceName="colorPickerPopup" HeaderText="Color Dialog" CloseAction="OuterMouseClick">
                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <div id="colorpicker"></div>
                        <dx:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="false" Text="Apply">
                            <ClientSideEvents Click="onColorApply" />
                        </dx:ASPxButton>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
            <dx:ASPxHtmlEditor runat="server" ID="htmlEditor" Html='aaa<span style="background-color: #ff6600;">aaaa</span>aaa<span style="color: #99cc00;">aaaaaa</span>aa'>
                <ClientSideEvents Init="onInit" />
                <Toolbars>
                    <dx:HtmlEditorToolbar>
                        <Items>
                            <dx:CustomToolbarButton CommandName="custombackcolor" Text="Back Color">
                                <Image>
                                    <SpriteProperties CssClass="image-custombackcolor" />
                                </Image>
                            </dx:CustomToolbarButton>
                            <dx:CustomToolbarButton CommandName="customforecolor" Text="Fore Color">
                                <Image>
                                    <SpriteProperties CssClass="image-customforecolor" />
                                </Image>
                            </dx:CustomToolbarButton>
                        </Items>
                    </dx:HtmlEditorToolbar>
                </Toolbars>
            </dx:ASPxHtmlEditor>
        </div>
    </form>
</body>
</html>
