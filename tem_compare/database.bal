import ballerina/io;
import ballerina/mysql;
import wso2/gmail;
import ballerina/config;
import ballerina/log;


endpoint mysql:Client testDB {
    host: "localhost",
    port: 3306,
    name: "abc_factory",
    username: "root",
    password: "",
    poolOptions: { maximumPoolSize: 5 },
    dbOptions: { useSSL: false }
};

documentation{A valid access token with gmail and google sheets access.}
string accessToken = "ya29.GlzzBSGLBOCWnVupeVxoASotTQ96idBYgeuRjndHazcjSTvJMT-ETsONdeVrcR99OkNzbz2UozbO2olcY6smB4PPiFxkI5Nz1hsWyaBLHIljqOO_lrjUgn4nRij8WQ";

documentation{The client ID for your application.}
string clientId = "547203970051-bfmlaf7h7u51ok8p4ehjg78mjksa6h1c.apps.googleusercontent.com";

documentation{The client secret for your application.}
string clientSecret = "sDGCBi0STWmu2i4I0EQcj8IR";

documentation{A valid refreshToken with gmail and google sheets access.}
string refreshToken = "1/9GmMPyEeVtWqjpp_rpVh657a-TkXMHKFoeVu9Zd3Tss12jmMcWCCKnDCMqEQzz8R";
documentation{Sender email address.}
string senderEmail = "andriperera.98@gmail.com";

documentation{The user's email address.}
string userId = "me";



endpoint gmail:Client gmailClient {
    clientConfig:{
        auth:{
            accessToken:accessToken,
            clientId:clientId,
            clientSecret:clientSecret,
            refreshToken:refreshToken
        }
    }
};



function main(string... args) {
    int ctem=0;
    int maxtem=0;
    int mintem=0;
    string cemail;

    // read user's input
    int userinput= check <int>io:readln("Enter the room id check the cureent id:");


    io:println("\nThe select operation - Select data from a table");
    var selectRet = testDB->select("SELECT * FROM standard_tem", ());
    table dt;
    match selectRet {
        table tableReturned => dt = tableReturned;
        error e => io:println("Select data from standard_tem table failed: "
                + e.message);
    }
    //io:println("\nThe select operation - Select data from a table");
    var selectRet2 = testDB->select("SELECT * FROM current_tem", ());
    table dt2;
    match selectRet2 {
        table tableReturned => dt2 = tableReturned;
        error e => io:println("Select data from current_tem table failed: "
                + e.message);
    }
    io:println("\nThe select operation Select tem");
    var current_room_tem = testDB->select("SELECT c_room_tem FROM current_tem WHERE c_room_id ="+userinput, ());

    table dt3;
    match current_room_tem {
        table tableReturned => dt3 = tableReturned;
        error e => io:println("Select data from current_tem table failed: "
                + e.message);
    }
    io:println("\nThe select operation  Sandard tem");
    var room_tem_min = testDB->select("SELECT min_tem FROM standard_tem WHERE room_id="+userinput, ());
    table dt4;
    match room_tem_min{
        table tableReturned => dt4 = tableReturned;
        error e => io:println("Select data from current_tem table failed: "
                + e.message);
    }
    io:println("\nThe select operation  Sandard tem");
    var room_tem_max = testDB->select("SELECT max_tem FROM standard_tem WHERE room_id="+userinput, ());
    table dt5;
    match room_tem_max{
        table tableReturned => dt5 = tableReturned;
        error e => io:println("Select data from current_tem table failed: "
                + e.message);
    }



    ///////////////////////////////////////////////////////////////////////////

    io:println("\nConvert the standard tem table into json");
    var jsonConversionRet = <json>dt;
    match jsonConversionRet {
        json jsonRes => {
            io:print("room tem details: ");
            io:println(io:sprintf("%s", jsonRes));
            //io:println(io:sprintf("%s", jsonRes[0].getKeys()));


        }
        error e => io:println("Error in table to json conversion");
    }
    io:println("\nConvert the current_tem table into json");
    var jsonConversionRet2 = <json>dt2;
    match jsonConversionRet2 {
        json jsonRes => {
            io:print("current room tem details: ");
            io:println(io:sprintf("%s", jsonRes));
            //io:println(io:sprintf("%s", jsonRes[0].getValues()));


        }
        error e => io:println("Error in table to json conversion");
    }

    io:println("\n //////////////////////////////////////////////////////////////////////////////////////////////////////");
    io:println("\nConvert the tem  into json");
    var jsonConversionRet3 = <json>dt3;
    match jsonConversionRet3 {
        json jsonRes3 => {
            io:print("current room tem details: ");
            io:println(io:sprintf("%s", jsonRes3));
            io:println(io:sprintf("%s", jsonRes3[0].c_room_tem));
            ctem=check <int> jsonRes3[0].c_room_tem ;


        }
        error e => io:println("Error in table to json conversion");
    }

    io:println("\nConvert the min tem  into json");
    var jsonConversionRet4 = <json>dt4;
    match jsonConversionRet4 {
        json jsonRes4 => {
            io:print("room min tem  details: ");
            io:println(io:sprintf("%s", jsonRes4));
            io:println(io:sprintf("%s", jsonRes4[0].min_tem));
           mintem=check <int> jsonRes4[0].min_tem;


        }
        error e => io:println("Error in table to json conversion");
    }

    io:println("\nConvert the max tem  into json");
    var jsonConversionRet5= <json>dt5;
    match jsonConversionRet5{
        json jsonRes5 => {
            io:print("room tem max details: ");
            io:println(io:sprintf("%s", jsonRes5));
            io:println(io:sprintf("%s", jsonRes5[0].max_tem));
            maxtem=check <int> jsonRes5[0].max_tem;


        }
        error e => io:println("Error in table to json conversion");
    }
/////////////////////////////////////////////////////////////////////////




    io:print("\n//////////////////////////////////////////////////////");
    io:print("\nresult...............................................");
    // Declare boolian flag to set isinrange or Not
    boolean isinrange = false;
    if(ctem!=0){
        if(mintem<ctem && ctem<maxtem){
            isinrange =true;
            io:print("\nroom tem is in range "+ctem);
            io:print("\n"+mintem + "-"+maxtem);
        }
        else{

            isinrange =false;
            io:print("\nroom tem is not in range "+ctem);
            io:println("\nThe select email");

            var email = testDB->select("SELECT relavant_emails FROM current_tem WHERE c_room_id="+userinput ,());
            table dt6;
            match email{
                table tableReturned => dt6 = tableReturned;
                error e => io:println("Select data from current_tem table failed: "
                        + e.message);
            }

            io:println("\nConvert email  into json");
            var jsonConversionRet6= <json>dt6;
            match jsonConversionRet6{
                json jsonRes6 => {
                    io:print("room email details: ");
                    io:println(io:sprintf("%s", jsonRes6));
                    io:println(io:sprintf("%s", jsonRes6[0].relavant_emails));
                   cemail=check <string> jsonRes6[0].relavant_emails;
                    sendEmail(cemail,"test1","room"+userinput+" "+"temperature is not up to standard.\nCurrent temperature:"+ctem+".Standard temperature range:"+mintem+"-"+maxtem);



                }
                error e => io:println("Error in table to json conversion");
            }



        }
    }
    io:print("\n//////////////////////////////////////////////////////");


    testDB.stop();
}

function handleUpdate(int|error returned, string message) {
    match returned {
        int retInt => io:println(message + " status: " + retInt);
        error e => io:println(message + " failed: " + e.message);
    }
}

  //  Send mail
function sendEmail(string Email, string name, string body) {
        //Create html message
        gmail:MessageRequest messageRequest;
        messageRequest.recipient = Email;
        messageRequest.sender = senderEmail;
        messageRequest.subject = "Error:temperature is not upto standard";
        messageRequest.messageBody = body;
        messageRequest.contentType = gmail:TEXT_HTML;

        var sendMessageResponse = gmailClient->sendMessage(userId, untaint messageRequest);
        string messageId;
        string threadId;
        match sendMessageResponse{
            (string, string) sendStatus => {
                (messageId, threadId) = sendStatus;
                log:printInfo("Sent email to " + Email + " with message Id: " + messageId + " and thread Id:"
                        + threadId);
            }
            gmail:GmailError e => log:printInfo(e.message);
        }
}

