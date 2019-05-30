//Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/http;
import ballerina/log;

@http:ServiceConfig {
    basePath : "/employee"
}
service echo on new http:Listener(9090) {
    
    @http:ResourceConfig {
        methods: ["POST"],
        path : "/filter"
    }
    resource function echo(http:Caller caller, http:Request request) {
        var payload = request.getJsonPayload(); //Returns json|error
        http:Response response = new;

        //Compatible with JSON arrays
        if(payload is json[]) {
            json[] jsonPayload = payload;
            
            foreach var x in payload {
                io:println(x);
                response = validateJSON(x); //Validate each payload

                //If the response is 500, ie something happend, break from the loop and send the response
                if(response.statusCode == 500) {
                    break;
                } else {
                    response.setPayload(untaint payload);
                } 
            }
        } else if (payload is json) {
            response = validateJSON(payload);
        } else {
            response.statusCode = 500;
            response.setPayload("Payload is not a valid JSON format");
        }

        var result = caller -> respond(response);
        if(result is error) {
            log:printError("Error in responding", err = result);
        }
    }
}

function validateJSON(json payload) returns http:Response {
    http:Response response = new;
    response.setJsonPayload(untaint payload); 

    if(!validateUsername(payload.username)) {
        io:println("Username is not valid");

        string payloadResponse_String = "Username "+payload.username.toString()+" in "+payload.toString()+" is not valid";
        json payloadResponse = <json>payloadResponse_String;
        response.setJsonPayload(untaint payloadResponse);
        response.statusCode = 500;
    }

    if(!validateCountry(payload.country)) {
        io:println("Country not valid.");

        string payloadResponse_String = "Country " +payload.country.toString()+ " in " +payload.toString()+" is not valid";
        json payloadResponse = <json> payloadResponse_String;
        response.setJsonPayload(untaint payloadResponse);
        response.statusCode = 500;
    }

    if(!validateEmail(payload.email)) {
        io:println("Email not valid");

        string payloadResponse_String = "Email "+payload.email.toString()+" in "+ payload.toString()+" is not valid";
        json payloadResponse = <json> payloadResponse_String;
        response.setJsonPayload(untaint payloadResponse);
        response.statusCode = 500;
    }

    return response;
}

//VALIDATION FUNCTIONS    
function validateUsername(json payload) returns boolean {
    io:println("Username : " + payload.toString());

    var result = payload.toString().matches("[a-zA-Z]+"); 

    if(result is error) {
        return false;
    } else {
        return result;
    }
}

function validateCountry(json payload) returns boolean {
    io:println("Country : " + payload.toString());
    var result = payload.toString().matches("[a-zA-Z]+");

    if(result is error) {
        return false;
    } else {
        return result;
    }
}

function validateEmail(json payload) returns boolean {    
    io:println("Email : " + payload.toString());
    var result = payload.toString().matches("^([a-zA-Z0-9._]+)+@[a-zA-Z_]+?\\.[a-zA-Z]{2,3}$");

    if(result is error) {
        return false;
    } else {
        return result;
    }
}

