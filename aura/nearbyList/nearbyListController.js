({
    requestNearbyRecords: function(cmp, event){        
        var recordId = cmp.get('v.recordId');
        var dataSetId = cmp.get('v.dataSetId');
        var recordLimit = cmp.get('v.recordLimit');
        var range = cmp.get('v.range');
        var units = cmp.get('v.units') === 'km' ? 'km': 'mi';
        var qualityFilter = cmp.get('v.qualityFilter');
        var fieldsToDisplay = cmp.get('v.fieldsToDisplay');
        var highQualityHash = {
            CUSTOM: true,
            ROOFTOP: true,
            RANGE_INTERPOLATED: true
        };
        var recordFilter = function(record){
            if(record.id === recordId){
                return false;
            }

            if(qualityFilter){
                return !!highQualityHash[record.geocodeQuality];
            }

            return true;
        };

        var actionGetUITheme = cmp.get("c.getUITheme");
        actionGetUITheme.setCallback(this, function(res) {
            cmp.set("v.showMapPin",true);   // launch map search
			if(res.getReturnValue() == 'Theme4t'){
				cmp.set("v.isSF1",true);
			}else{
				cmp.set("v.isSF1",false);
			}
        });
        $A.enqueueAction(actionGetUITheme);
  
        //This is called first, at the bottom of requestNearbyRecords();
        var initSearch = function(){
            if(recordId != 'null' && recordId != null && recordId != ''){
            	doSearch(recordId);
            
            }else{ //Attempt to find user location and use that for search center
            	if(navigator.geolocation) {
					//Get user position
					navigator.geolocation.getCurrentPosition(
						function(position){//Sucess
							cmp.set("v.latitude",position.coords.latitude);
							cmp.set("v.longitude",position.coords.longitude);
							doSearch(null,position.coords.latitude,position.coords.longitude);
						},
						function(error){//Error TODO
							var message = '';
							if(error.code == 1){
								message = 'Unable to access GPS.';
							}else if(error.code == 2){
								message = 'Unable to locate position.';
							}else if(error.code == 3){
								message = 'Unable to locate position due to timeout.';
							}
							cmp.set('v.error', message);
						},
						{ //Geolocation options
							enableHighAccuracy: true, 
							maximumAge        : 0, 
							timeout           : 10000
						}
					);
				}else{
					cmp.set('v.error', 'Unable to locate current position. Please ensure GPS or location services is enabled.');
				} 
            }
        }
        
        var doSearch = function(recordId,lat,lng){

            // remoting call
            // https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/controllers_server_actions_call.htm
            var action = cmp.get('c.getNearbyRecords');
            action.setParams({
                dataSetIdentifier: dataSetId,
                recordId: recordId,
                range: range,
                units: units,
                latitude: lat,
                longitude: lng
            });
            action.setCallback(this, function(res){
                var state = res.getState();
                if(state === 'SUCCESS'){
                    var records = JSON.parse(res.getReturnValue()).records;
    
                    records = records.filter(recordFilter).slice(0, recordLimit);
    
                    records.forEach(function(record){
                        record.distance = (Math.round((record.distance + 0.00001) * 100) / 100).toFixed(2);

                        // limit number of fields returned
                        if (fieldsToDisplay > 0 && record.additionalFields) {
                            if (record.additionalFields.length > fieldsToDisplay) {
                                record.additionalFields = record.additionalFields.slice(0, fieldsToDisplay);
                            }
                        }
                        else {
                            record.additionalFields = [];
                        }
                    });

                    cmp.set('v.searchDone', true);
                    cmp.set('v.records', records);
                    if(records.length === 0) cmp.set('v.error', 'No records found...');
                }else if(state === 'ERROR'){
                    var errors = res.getError();
                    cmp.set('v.searchDone', true);
                    if(errors){
                        if(errors[0] && errors[0].message){
                            console.log('Error message: ' + errors[0].message);
                            cmp.set('v.error', errors[0].message);
                        }
                    }else{
                        console.log('Unknown error');
                        cmp.set('v.error', 'Unknown error');
                    }
                }
            });
            $A.enqueueAction(action);
        }
        
        initSearch();
	},
	navigateToSObject: function(cmp, event){
		//If not is SF1, make sure event only fires if clicking the link, not the entire LI element
        if(cmp.get("v.isSF1") == false && event.target.tagName != 'A') {
            return false;
		}

		var id = event.currentTarget.getAttribute('data-id')
		var navEvent = $A.get('e.force:navigateToSObject');
		navEvent.setParams({
			recordId: id
		});
		navEvent.fire();
	},
	navigateToMap: function(cmp, event){
		var params = event.currentTarget.getAttribute('data-params');
		var action = cmp.get('c.isCommunity');
		var urlEvent = $A.get('e.force:navigateToURL');
		var url = '/apex/';
		var getNamespace = cmp.get('c.getNamespace');

		getNamespace.setCallback(this, function (res) {
			url += res.getReturnValue() + 'Map' + params;

			action.setCallback(this, function (res) {
				if (res.getReturnValue()) {
					url = '/sfdcpage/' + encodeURIComponent(url);
				}
				
				urlEvent.setParams({
					url: url
				});
				
				urlEvent.fire();
			});
			
			$A.enqueueAction(action);
		});
		
		$A.enqueueAction(getNamespace);

	}
})