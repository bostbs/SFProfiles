@isTest
private class BabsonBlockDateControllerTest {
	public BabsonBlockDateControllerTest() {
		
	}

	static testMethod void testDateFormats() {
		Datetime startDate = Datetime.newInstance(2016, 6, 1, 12, 0, 0); // June 1st at noon
		Datetime endDate = Datetime.newInstance(2016, 6, 1, 13, 0, 0); // June 1st at 1pm
		
		// Date block controller
		BabsonDateBlockController dateBlock = New BabsonDateBlockController();
		dateBlock.cStartDate = startDate;
		dateBlock.cEndDate = endDate;

		system.assert(dateBlock.startMonth == 'June');
		system.assert(dateBlock.startDay == 'Wednesday');
		system.assert(dateBlock.startDayNum == '1');
		system.assert(dateBlock.startTime == '12:00 pm');
		system.assert(dateBlock.endTime == '1:00 pm');
	}
}