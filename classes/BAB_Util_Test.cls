@isTest
public class BAB_Util_Test{
    
    private static testMethod void test_Method() {
    
        BAB_TestUtil objTestUtil = new BAB_TestUtil();
        User objCommunityUser = objTestUtil.createCommunityUser();
    
        system.runAs(objCommunityUser){
        
            //system.assertEquals(false,BAB_Util.is_SSFUser());
            system.assert(String.isNotBlank(BAB_Util.constructProfilesList(new Set<String>())));
            system.assertEquals(true, BAB_Util.doesContainsItemFromSet(new Set<String>{'Arts','Commerce'} , new Set<String>{'Arts'}));
            
            List<SelectOption> lstSelectOption = new List<SelectOption>();
            lstSelectOption.add(new SelectOption('test','test'));
            lstSelectOption.add(new SelectOption('test &amp; test','test &amp; test'));
            BAB_Util.htmlEscapeSelectOptions(lstSelectOption);
        }
    }
}