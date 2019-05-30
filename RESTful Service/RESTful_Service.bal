import ballerina/http;
import ballerina/io;
import ballerina/grpc;
import ballerina/log;

listener http:Listener httpListener = new(9090);

//Order management is done using an in-memory map
//Add some sample orders to the 'ordersMap' at startup
map<json> ordersMap = {};

//RESTful service
@http:ServiceConfig { basePath: "/ordermgt" } 
service orderMgt on httpListener {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/order/{orderId}"
    }
    resource function findOrder(http:Caller caller, http:Request req, string orderId) {
        //Find the requested order from the map and retrieve it in JSON format 
        json? payload = ordersMap[orderId];
        http:Response response = new;

        if(payload == null) {
            payload = "Order : " + orderId + " cannot be found.";
        }

        // Set the JSON payload in the outgoing reponse message
        response.setJsonPayload(untaint payload);

        var result = caller -> respond(response);
        if(result is error) {
            log:printError("Error sending response", err = result);
        }
    }

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/order"
    }
    resource function addOrder(http:Caller caller, http:Request req) {
        http:Response response = new;
        var orderReq = req.getJsonPayload();

        if(orderReq is json) {
            string orderId = orderReq.Order.ID.toString();
            ordersMap[orderId] = orderReq;
        
            //Create reponse message 
            json payload = { status: "Order created." , orderId : orderId };
            response.setJsonPayload(untaint payload, contentType = "application/json");
            response.statusCode = 201;
            response.setHeader("Location","http://localhost:9090/ordermgt/order/" + orderId);

            //Send response to the client
            var result = caller -> respond(response);
            if(result is error) {
                log:printError("Error sending response", err = result);
            }
        } else {
            response.statusCode = 400;
            response.setPayload("Invalid payload recieved");

            var result = caller -> respond(response);
            if(result is error) {
                log:printError("Error sending response", err = result);
            }
        }
    }

    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/order/{orderId}"
    }
    resource function updateOrder(http:Caller caller, http:Request req, string orderId) {
        var updatedOrder = req.getJsonPayload();
        http:Response response = new;

        if(updatedOrder is json) {
            //Find the order that needs to be updated and retrieve it in JSON format
            json existingOrder = ordersMap[orderId];

            //Updating exiting order with the attributes of the updated order
            if(existingOrder != null) {
                existingOrder.Order.Name = updatedOrder.Order.Name;
                existingOrder.Order.Description = updatedOrder.Order.Description;
                ordersMap[orderId] = existingOrder;
            } else {
                existingOrder = "Order :" + orderId + " cannot be found.";
            }
            //Set the json payload to the outgoing response message to the client
            response.setJsonPayload(untaint existingOrder, contentType = "application/json");

            var result = caller -> respond(response);
            if(result is error) {
                log:printError("Error sending response", err = result);
            }

        } else {
            response.statusCode = 400;
            response.setPayload("Invalid payload received");
            var result = caller -> respond(response);

            if(result is error) {
                log:printError("Error sending response", err = result);
            }
        }

    }

    @http:ResourceConfig {
        methods: ["DELETE"],
        path: "/order/{orderId}"
    }
    resource function cancelOrder(http:Caller caller, http:Request req, string orderId) {
        http:Response response = new;
        _=ordersMap.remove(orderId);

        json payload = "Order : " + orderId + " removed.";
        response.setJsonPayload(untaint payload, contentType = "application/json");

        var result = caller->respond(response);
        if(result is error) {
            log:printError("Error sending response", err = result);
        }
    }

}