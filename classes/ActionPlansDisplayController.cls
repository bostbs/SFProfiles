public class ActionPlansDisplayController {

    public ActionPlansDisplayController(ApexPages.StandardSetController controller) {
        axplIsClassic = checkTheme();
    }

    Boolean axplIsClassic;
    
    public ActionPlansDisplayController() {
        axplIsClassic = checkTheme();
    }
    
    public ActionPlansDisplayController(ApexPages.StandardController acon) {
        axplIsClassic = checkTheme();
    }
    
    public ActionPlansDisplayController(ImportTemplateController controller) {
        axplIsClassic = checkTheme();
    }
    
    private boolean checkTheme() {
        return UserInfo.getUiThemeDisplayed() != 'Theme4d';
    }
    
    public boolean getAxplIsClassic (){
        return axplIsClassic;
    }
}