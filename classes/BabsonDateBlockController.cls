public with sharing class BabsonDateBlockController {
	public BabsonDateBlockController() {
		
	}

	public Datetime cStartDate {get;set;}
	public Datetime cEndDate {get;set;}

	public String startMonth{
        get{
        	String formatted = '';
    
            if(cStartDate != null)
                formatted =  cStartDate.format('MMMM');
                
            return formatted;
        }
    }

    public String startDay{
        get{
        	String formatted = '';
    
            if(cStartDate != null)
                formatted =  cStartDate.format('EEEE');
                
            return formatted;
        }
    }

    public String startDayNum{
        get{
        	String formatted = '';
    
            if(cStartDate != null)
                formatted =  cStartDate.format('d');
                
            return formatted;
        }
    }

    public String startTime{
        get{
        	String formatted = '';
    
            if(cStartDate != null)
                formatted =  cStartDate.format('h:mm a');
                
            return formatted;
        }
    }

    public String endTime{
        get{
        	String formatted = '';
    
            if(cEndDate != null)
                formatted =  cEndDate.format('h:mm a');
                
            return formatted;
        }
    }
}