# Filtering a Message 
Ballerina service that validates contents of JSON payloads

## How it works
- The service recieves the payload and checks if it is a valid json payload
- It sends the payload for validation which checks each field in the payload accoring to the specified validation restrictions.
- If the payload is invalid a reponse indicating the field that is invalid
- If the payload is valid the same payload is returned 


## Steps to Deploy

- Setup [Ballerina 0.991.0](https://ballerina.io/downloads/)
- To start the service, navigate to the ```Filtering_a_message directory``` and run the following command ``` Ballerina run ValidateMessages.bal ``` 

## Usecase
The following payload can be sent for validation 

```json
[
    {
        "id": "1wa2435c-t2x2-1zc3-fr7s-c91wtyq5qe33",
        "username": "charles",
        "country": "Australia",
        "email": "charles@gmail.au"
    },{
        "id": "1wa2135c-t2d3-2zx3-ft7s-c91wtqq5fe34",
        "username": "Akihito",
        "country": "Japan",
        "email": "Akihito@gmail",
    },{
        "id": "1wa2435c-t2x2-1zc3-fr7s-c96wtyq5qe33",
        "username": "Trey",
        "country": "Germany2",
        "email": "Trey@yahoo.com"
    },{
        "id": "1wa2435c-t2x2-1zc3-fr7s-c92wtyq5qe24",
        "username": "Tester1121",
        "country": "Tester", 
        "email": "tester@tester.com"
    }
]
```

The service will return responses based on the invalid fields in the payload



