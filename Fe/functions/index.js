// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

//MARK: Heart Rate Function
exports.heartRateDataAnalysis = functions.https.onRequest(async (req, res) => {
    
    // Get first name from request parameter
    const fName = req.query.fName;
    if (fName == null || fName == "") {
        console.log("fName is empty.");
    }
    console.log("First Name: ", fName);
    
    // Get fcmToken from request parameter
    const fcmToken = req.query.fcmToken;
    if (fcmToken == null || fcmToken == "") {
        res.send("fcmToken is empty. Cannot proceed with hr analysis");
    }
    console.log("fcmToken: ", fcmToken);
    
    // Get emergency phone from request parameter
    const emergencyPhone = req.query.emergencyPhone;
    if (emergencyPhone == null || emergencyPhone == "") {
        console.log("emergencyPhone is empty. Cannot send message to emergency contact.");
    }
    console.log("Emergency Phone: ", emergencyPhone);
    
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
    console.log("Low: ", hrLowThreshold, " High: ", hrHighThreshold);

    
    // Evaluate the heart rate data, send notification if above/below threshold values
    const data = req.query.data;
    var jsonObject;
    var returnBody = [];
    
    // Verify data is not empty and parse to JSON data
    if (data == null || data == "") {
        console.log("data is empty. Cannot proceed with hr analysis");
        return res.status(404).send("data is empty. Cannot proceed with hr analysis");
    } else {
        try {
            jsonObject = JSON.parse(data);
        } catch (error) {
            return res.status(404).send("Unable to process the json data.");
        }
        
    }
    console.log("data: ", jsonObject);
    
    // Loop through the JSON values
    for (var object in jsonObject) {
        
        // Convert Date
        var date = Math.floor(jsonObject[object].dateTime);
        try {
            date = new Date(date);
        } catch (error) {
            console.log("Cannot convert date: ", jsonObject[object].dateTime);
        }
        
        // Store heart rate in an easier variable
        var hr = jsonObject[object].heartRate;
        
        // Evaluate if low threshold is triggered
        if (hr < hrLowThreshold) {
            console.log('Trigger: Heart rate ', hr, ' is lower than low threshold ', hrLowThreshold);
            const thresholdsTriggered = {hrLowThreshold:hrLowThreshold, hr:hr, dateTime:date};
            returnBody.push(hr); // Store in response
        }
        
        // Evaluate if high threshold is triggered
        if (hr > hrHighThreshold) {
            console.log('Trigger: Heart rate ', hr, ' is higher than high threshold ', hrHighThreshold);
            const thresholdsTriggered = {hrHighThreshold:hrHighThreshold, hr:hr, dateTime:date};
            returnBody.push(hr); // Store in response
        }
    }
    
    // If body is empty, no notification, else, send a notification
    if (returnBody.length == 0) {
        body.push("Successfully processed heart rate data analysis function");
    } else {
        var hrValues = "";
        for (var i=0; i < returnBody.length; i++) {
            if (hrValues == "") {
                hrValues = returnBody[i];
            } else {
                hrValues = hrValues + ", " + returnBody[i];
            }
        }
        
        // Create a notification
        let title = "Threshold Triggered";
        let body = `Fe noticed HR value(s) of ${hrValues} which are outside of your set thresholds.`;
        const message = {
            notification : {title: title, body: body},
            token : fcmToken,
            data : {}
        };
        admin.messaging().send(message).then(response => {
            console.log("Sent message");
        }).catch(error => {
            console.error(error);
            console.log("Error sending message");
        });
    }
    
    return res.status(200).send(returnBody);
});

//MARK: Blood Oxygen Function
    exports.bloodOxygenDataAnalysis = functions.https.onRequest(async (req, res) => {
        var body = [];
        
        // Get first name from request parameter
        const fName = req.query.fName;
        if (fName == null || fName == "") {
            console.log("fName is empty.");
        }
        console.log("First Name: ", fName);
        
        // Get fcmToken from request parameter
        const fcmToken = req.query.fcmToken;
        if (fcmToken == null || fcmToken == "") {
            res.send("fcmToken is empty. Cannot proceed with hr analysis");
        }
        console.log("fcmToken: ", fcmToken);
        
        // Get emergency phone from request parameter
        const emergencyPhone = req.query.emergencyPhone;
        if (emergencyPhone == null || emergencyPhone == "") {
            console.log("emergencyPhone is empty. Cannot send message to emergency contact.");
        }
        console.log("Emergency Phone: ", emergencyPhone);
        
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
        console.log("Low: ", bldOxLowThreshold, " High: ", bldOxHighThreshold);

        
        // Evaluate the heart rate data, send notification if above/below threshold values
        const data = req.query.data;
        var jsonObject;
        
        // Verify data is not empty and parse to JSON data
        if (data == null || data == "") {
            console.log("data is empty. Cannot proceed with blood oxygen analysis");
            return res.status(404).send("data is empty. Cannot proceed with blood oxygen analysis");
        } else {
            try {
                jsonObject = JSON.parse(data);
            } catch (error) {
                return res.status(404).send("Unable to process the json data.");
            }
        }
        console.log("data: ", jsonObject);
        
        // Loop through the JSON values
        for (var object in jsonObject) {
            
            // Convert Date
            var date = jsonObject[object].dateTime;
            try {
                date = new Date(date);
            } catch (error) {
                console.log("Cannot convert date: ", jsonObject[object].dateTime);
            }
            
            // Store blood oxygen value in an easier variable
            var bldOx = jsonObject[object].bloodOxygen;
            
            // Evaluate if low threshold is triggered
            if (bldOx < bldOxLowThreshold) {
                console.log('Trigger: Blood oxygen ', bldOx, ' is lower than low threshold ', bldOxLowThreshold);
                const thresholdsTriggered = {bldOxLowThreshold:bldOxLowThreshold, bloodOxygen:bldOx, dateTime:date};
                body.push(thresholdsTriggered); // Store in response
            }
            
            // Evaluate if high threshold is triggered
            if (bldOx > bldOxHighThreshold) {
                console.log('Trigger: Blood oxygen ', bldOx, ' is higher than high threshold ', bldOxHighThreshold);
                const thresholdsTriggered = {bldOxHighThreshold:bldOxHighThreshold, bloodOxygen:bldOx, dateTime:date};
                body.push(thresholdsTriggered); // Store in response
            }
        }
        
        // If no thresholds broken
        if (body.length == 0) {
            body.push("Successfully processed blood oxygen data analysis function");
        } else {
            
            var bldOxValues = "";
            for (var i=0; i < body.length; i++) {
                if (bldOxValues == "") {
                    bldOxValues = returnBody[i];
                } else {
                    bldOxValues = bldOxValues + ", " + returnBody[i];
                }
            }
            // Create a notification
            let title = "Threshold Triggered";
            let body = `Fe noticed Blood Oxygen value(s) of ${bldOxValues} which are outside of your set thresholds.`;
            const message = {
                notification : {title: title, body: body},
                token : fcmToken,
                data : {}
            };
            
            admin.messaging().send(message).then(response => {
                console.log("Sent message");
            }).catch(error => {
                console.error(error);
                console.log("Error sending message");
            });
        }
        
        return res.status(200).send(JSON.stringify(body));
});


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Take the text parameter passed to this HTTP endpoint and insert it into
// Firestore under the path /messages/:documentId/original
//exports.addMessage = functions.https.onRequest(async (req, res) => {
//  // Grab the text parameter.
//  const original = req.query.text;
//  // Push the new message into Firestore using the Firebase Admin SDK.
//  const writeResult = await admin.firestore().collection('messages').add({original: original});
//  // Send back a message that we've successfully written the message
//  res.json({result: `Message with ID: ${writeResult.id} added.`});
//});

// Listens for new messages added to /messages/:documentId/original and creates an
// uppercase version of the message to /messages/:documentId/uppercase
//exports.makeUppercase = functions.firestore.document('/messages/{documentId}')
//    .onCreate((snap, context) => {
//      // Grab the current value of what was written to Firestore.
//      const original = snap.data().original;
//
//      // Access the parameter `{documentId}` with `context.params`
//      functions.logger.log('Uppercasing', context.params.documentId, original);
//
//      const uppercase = original.toUpperCase();
//
//      // You must return a Promise when performing asynchronous tasks inside a Functions such as
//      // writing to Firestore.
//      // Setting an 'uppercase' field in Firestore document returns a Promise.
//      return snap.ref.set({uppercase}, {merge: true});
//    });
