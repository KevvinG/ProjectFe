// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

//MARK: Heart Rate Function
exports.heartRateDataAnalysis = functions.https.onRequest(async (req, res) => {
    var returnBody = [];
    
    // Get first name from request parameter
    const fName = req.query.fName;
    if (fName == null || fName == "") {
        console.log("fName is empty.");
    }
    
    // Get fcmToken from request parameter
    const fcmToken = req.query.fcmToken;
    if (fcmToken == null || fcmToken == "") {
        returnBody.push("fcmToken is empty. Cannot proceed with hr analysis");
        return res.status(400).send(returnBody);
    }
    
    // Get emergency phone from request parameter
    const emergencyPhone = req.query.emergencyPhone;
    if (emergencyPhone == null || emergencyPhone == "") {
        console.log("emergencyPhone is empty. Cannot send message to emergency contact.");
    }
    
    // Get low threshold value or default 40 from request parameter
    var hrLowThreshold = req.query.hrLowThreshold;
    if (hrLowThreshold == null || hrLowThreshold == "") {
        console.log("hrLowThreshold is empty. Using default 40");
        hrLowThreshold = 40;
    }
    
    // Get High Threshold Value or default 100 from request parameter
    var hrHighThreshold = req.query.hrHighThreshold;
    if (hrHighThreshold == null || hrLowThreshold == "") {
        console.log("hrHighThreshold is empty. Using default 100");
        hrHighThreshold = 100;
    }

    // Evaluate the heart rate data, send notification if above/below threshold values
    const data = req.query.data;
    var jsonObject;
    
    
    // Verify data is not empty and parse to JSON data
    if (data == null || data == "") {
        returnBody.push("data is empty. Cannot proceed with hr analysis");
        return res.status(400).send(returnBody);
    } else {
        try {
            jsonObject = JSON.parse(data);
        } catch (error) {
            returnBody.push("Unable to process the json data.");
            return res.status(400).send(returnBody);
        }
    }
    
    // Loop through the JSON values
    for (var object in jsonObject) {
        
        // Convert Date
        var dateString = String(jsonObject[object].dateTime * 1000);
        var dateArr = dateString.split(".");
        dateString = dateArr[0];
        var date = "";
        try {
            date = new Date(0);
            date.setUTCSeconds(dateString);
            console.log(date);
        } catch (error) {
            console.log("Cannot convert date.");
        }
        
        // Store heart rate in an easier variable
        var hr = jsonObject[object].heartRate;
        
        // Evaluate if low threshold is triggered
        if (hr < hrLowThreshold) {
            const thresholdsTriggered = {hrLowThreshold:hrLowThreshold, hr:hr, dateTime:date};
            returnBody.push(thresholdsTriggered); // Store in response
        }
        
        // Evaluate if high threshold is triggered
        if (hr > hrHighThreshold) {
            const thresholdsTriggered = {hrHighThreshold:hrHighThreshold, hr:hr, dateTime:date};
            returnBody.push(thresholdsTriggered); // Store in response
        }
    }
    
    // If body is empty, no notification, else, send a notification
    if (returnBody.length == 0) {
        returnBody.push("Successfully processed heart rate data analysis function");
    } else {
        var hrValues = "";
        for (var i=0; i < returnBody.length; i++) {
            if (hrValues == "") {
                hrValues = returnBody[i].hr;
            } else {
                hrValues = hrValues + ", " + returnBody[i].hr;
            }
        }
        
        // Create a notification
        let title = "HR Threshold Triggered";
        let body = `Fe noticed HR value(s) of ${hrValues} in the last 5 minutes which are outside of your set thresholds`;
        const message = {
            notification : {title: title, body: body},
            token : fcmToken,
            data : {}
        };

        admin.messaging().send(message).then(response => {
            returnBody.push("Successfully sent HR push notification");
            return res.status(200).send(returnBody);
        }).catch(error => {
            returnBody.push(`Error sending HR push notification: ${error}`);
            return res.status(400).send(returnBody);
        });
    }
});

//MARK: Blood Oxygen Function
    exports.bloodOxygenDataAnalysis = functions.https.onRequest(async (req, res) => {
        var returnBody = [];
        
        // Get first name from request parameter
        const fName = req.query.fName;
        if (fName == null || fName == "") {
            console.log("fName is empty.");
        }
        
        // Get fcmToken from request parameter
        const fcmToken = req.query.fcmToken;
        if (fcmToken == null || fcmToken == "") {
            returnBody.push("fcmToken is empty. Cannot proceed with blood Oxygen analysis");
            return res.status(400).send(returnBody);
        }
        
        // Get emergency phone from request parameter
        const emergencyPhone = req.query.emergencyPhone;
        if (emergencyPhone == null || emergencyPhone == "") {
            console.log("emergencyPhone is empty. Cannot send message to emergency contact.");
        }
        
        // Get low threshold value or default 90 from request parameter
        var bldOxLowThreshold = req.query.bldOxLowThreshold;
        if (bldOxLowThreshold == null || bldOxLowThreshold == "") {
            console.log("bldOxLowThreshold is empty. Using default 90");
            bldOxLowThreshold = 90;
        }
        
        // Get High Threshold Value or default 110 from request parameter
        var bldOxHighThreshold = req.query.bldOxHighThreshold;
        if (bldOxHighThreshold == null || bldOxHighThreshold == "") {
            console.log("bldOxHighThreshold is empty. Using default 110");
            bldOxHighThreshold = 110;
        }
        
        // Evaluate the heart rate data, send notification if above/below threshold values
        const data = req.query.data;
        var jsonObject;
        
        // Verify data is not empty and parse to JSON data
        if (data == null || data == "") {
            returnBody.push("data is empty. Cannot proceed with blood oxygen analysis");
            return res.status(400).send(returnBody);
        } else {
            try {
                jsonObject = JSON.parse(data);
            } catch (error) {
                returnBody.push("Unable to process the json data.");
                return res.status(400).send(returnBody);
            }
        }
        
        // Loop through the JSON values
        for (var object in jsonObject) {
            
            // Convert Date
            var dateString = String(jsonObject[object].dateTime * 1000);
            var dateArr = dateString.split(".");
            dateString = dateArr[0];
            var date = "";
            try {
                date = new Date(0);
                date.setUTCSeconds(dateString);
                console.log(date);
            } catch (error) {
                console.log("Cannot convert date.");
            }
            
            // Store blood oxygen value in an easier variable
            var bldOx = jsonObject[object].bloodOxygen;
            
            // Evaluate if low threshold is triggered
            if (bldOx < bldOxLowThreshold) {
                const thresholdsTriggered = {bldOxLowThreshold:bldOxLowThreshold, bloodOxygen:bldOx, dateTime:date};
                returnBody.push(thresholdsTriggered); // Store in response
            }
            
            // Evaluate if high threshold is triggered
            if (bldOx > bldOxHighThreshold) {
                const thresholdsTriggered = {bldOxHighThreshold:bldOxHighThreshold, bloodOxygen:bldOx, dateTime:date};
                returnBody.push(thresholdsTriggered); // Store in response
            }
        }
        
        // If no thresholds broken
        if (returnBody.length == 0) {
            returnBody.push("Successfully processed blood oxygen data analysis function");
        } else {
            var bldOxValues = "";
            for (var i=0; i < returnBody.length; i++) {
                if (bldOxValues == "") {
                    bldOxValues = returnBody[i].bloodOxygen;
                } else {
                    bldOxValues = bldOxValues + ", " + returnBody[i].bloodOxygen;
                }
            }
            // Create a notification
            let title = "Threshold Triggered";
            let body = `Fe noticed Blood Oxygen value(s) of ${bldOxValues} in the last 5 minutes which are outside of your set thresholds`;
            const message = {
                notification : {title: title, body: body},
                token : fcmToken,
                data : {}
            };
            
            admin.messaging().send(message).then(response => {
                returnBody.push("Successfully sent blood oxygen push notification");
                return res.status(200).send(returnBody);
            }).catch(error => {
                returnBody.push(`Error sending blood oxygen push notification: ${error}`);
                return res.status(400).send(returnBody);
            });
        }
});

//MARK: Med Reminder Function (NOT NEEDED ANYMORE)
//exports.medicationReminder = functions.https.onRequest(async (req, res) => {
//    var returnBody = [];
//
//    // Get fcmToken from request parameter
//    const fcmToken = req.query.fcmToken;
//    if (fcmToken == null || fcmToken == "") {
//        returnBody.push("fcmToken is empty. Cannot send Medication Reminder Notification");
//        return res.status(400).send(returnBody);
//    }
//
//    // Create a notification
//    let title = "Medication Reminder";
//    let body = `It is now 8:00 AM. Have you taken your medication today?`;
//    const message = {
//        notification : {title: title, body: body},
//        token : fcmToken,
//        data : {}
//    };
//
//    admin.messaging().send(message).then(response => {
//        returnBody.push("Successfully sent medication reminder push notification");
//        return res.status(200).send(returnBody);
//    }).catch(error => {
//        returnBody.push(`Error sending medication reminder push notification: ${error}`);
//        return res.status(400).send(returnBody);
//    });
//});
   
