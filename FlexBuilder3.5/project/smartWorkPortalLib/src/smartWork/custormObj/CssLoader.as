package smartWork.custormObj
{
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	import flash.text.FontStyle;
	
	public class CssLoader{
		private static var status:int = 0;
		[Embed(source="assets/img/closeButton.png")] private static var closeBtn:Class;
		[Embed(source="assets/img/increaseButton.png")] private static var increaseBtn:Class;
		[Embed(source="assets/img/decreaseButton.png")] private static var decreaseBtn:Class;
		[Embed(source="assets/img/window_minimize.png")] private static var window_minimizeBtn:Class;
		[Embed(source="assets/img/resizeHandler.png")] private static var resizeHandlerBtn:Class;
		
		
		public static function cssLoad():void {
			if(status == 0){
				var stylePanel:CSSStyleDeclaration = new CSSStyleDeclaration(".Panel");
				//stylePanel.setStyle("headerHeight", 26);
				stylePanel.setStyle("roundedBottomCorners", true);
				stylePanel.setStyle("borderThicknessTop", 0);
				stylePanel.setStyle("borderThicknessBottom", 3);
				stylePanel.setStyle("borderThicknessLeft", 3);
				stylePanel.setStyle("borderThicknessRight", 3);
				stylePanel.setStyle("borderAlpha", 1.0);
				stylePanel.setStyle("titleStyleName", "mypanelTitle");
				StyleManager.setStyleDeclaration(".Panel", stylePanel, false);
				
				var styleMypanelTitle:CSSStyleDeclaration = new CSSStyleDeclaration(".mypanelTitle");
				styleMypanelTitle.setStyle("fontFamily", "Tahoma");
				styleMypanelTitle.setStyle("fontSize", 11);
				styleMypanelTitle.setStyle("fontWeight", FontStyle.BOLD);
				
				var styleCloseBtn:CSSStyleDeclaration = new CSSStyleDeclaration(".closeBtn");
				styleCloseBtn.setStyle("upSkin", closeBtn);
				styleCloseBtn.setStyle("overSkin", closeBtn);
				styleCloseBtn.setStyle("downSkin", closeBtn);
				styleCloseBtn.setStyle("disabledSkin", closeBtn);
				StyleManager.setStyleDeclaration(".closeBtn", styleCloseBtn, false); 
				
				var styleIncreaseBtn:CSSStyleDeclaration = new CSSStyleDeclaration(".increaseBtn");
				styleIncreaseBtn.setStyle("upSkin", increaseBtn);
				styleIncreaseBtn.setStyle("overSkin", increaseBtn);
				styleIncreaseBtn.setStyle("downSkin", increaseBtn);
				styleIncreaseBtn.setStyle("disabledSkin", increaseBtn);
				StyleManager.setStyleDeclaration(".increaseBtn", styleIncreaseBtn, false); 
				
				var styleDecreaseBtn:CSSStyleDeclaration = new CSSStyleDeclaration(".decreaseBtn");
				styleDecreaseBtn.setStyle("upSkin", decreaseBtn);
				styleDecreaseBtn.setStyle("overSkin", decreaseBtn);
				styleDecreaseBtn.setStyle("downSkin", decreaseBtn);
				styleDecreaseBtn.setStyle("disabledSkin", decreaseBtn);
				StyleManager.setStyleDeclaration(".decreaseBtn", styleDecreaseBtn, false); 
				
				var styleMinimizeBtn:CSSStyleDeclaration = new CSSStyleDeclaration(".minimizeBtn");
				styleMinimizeBtn.setStyle("upSkin", window_minimizeBtn);
				styleMinimizeBtn.setStyle("overSkin", window_minimizeBtn);
				styleMinimizeBtn.setStyle("downSkin", window_minimizeBtn);
				styleMinimizeBtn.setStyle("disabledSkin", window_minimizeBtn);
				StyleManager.setStyleDeclaration(".minimizeBtn", styleMinimizeBtn, false); 
				
				var styleHiddenBtn:CSSStyleDeclaration = new CSSStyleDeclaration(".hiddenBtn");
				styleHiddenBtn.setStyle("upSkin", window_minimizeBtn);
				styleHiddenBtn.setStyle("overSkin", window_minimizeBtn);
				styleHiddenBtn.setStyle("downSkin", window_minimizeBtn);
				styleHiddenBtn.setStyle("disabledSkin", window_minimizeBtn);
				StyleManager.setStyleDeclaration(".hiddenBtn", styleHiddenBtn, false); 
				
				var styleResizeHndlr:CSSStyleDeclaration = new CSSStyleDeclaration(".resizeHndlr");
				styleResizeHndlr.setStyle("upSkin", resizeHandlerBtn);
				styleResizeHndlr.setStyle("overSkin", resizeHandlerBtn);
				styleResizeHndlr.setStyle("downSkin", resizeHandlerBtn);
				styleResizeHndlr.setStyle("disabledSkin", resizeHandlerBtn);
				StyleManager.setStyleDeclaration(".resizeHndlr", styleResizeHndlr, false); 
				
				var styleBoldLabelHndlr:CSSStyleDeclaration = new CSSStyleDeclaration(".custormTextInput");
				styleBoldLabelHndlr.setStyle("fontFamily", "Tahoma");
				//styleBoldLabelHndlr.setStyle("fontAntiAliasType", "advanced");
				//styleBoldLabelHndlr.setStyle("fontWeight", "bold");
				styleBoldLabelHndlr.setStyle("fontSize", 11);
				styleBoldLabelHndlr.setStyle("textAlign", "center");
				styleBoldLabelHndlr.setStyle("focusAlpha", "0");
				
				status = 1;
			}
		}
	}
}