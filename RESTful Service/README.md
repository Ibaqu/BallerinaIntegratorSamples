# RESTful Service
Ballerina service that simulates order creation, retrieval, update and delete through GET, POST, PUT and DELETE requests

## How it works 
- The service can recieve a payload via POST to create an order
- A request for a specific order can be sent via GET identified by order id
- An order can be edited via PUT identified by order id
- Orders can be deleted via DELETE 

## Steps to Deploy
- Setup [Ballerina 0.991.0](https://ballerina.io/downloads/)
- To start the service, navigate to the ```RESTful_Service``` directory and run the following command ```Ballerina run RESTful_Service.bal``` 

## Usecase 
The requests must be sent to ```localhost:9090/ordermgt/order``` 

A sample json payload can be sent via POST to be saved locally in the ordersMap

```json
{
    "Order" : {
        "ID" : "100",
        "Name" : "XYZ",
        "Description" : "Sample order."
    }
}

```
