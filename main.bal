import ballerina/http;
import ballerina/workflow;

service /processorder on new http:Listener(8080) {

    resource function post .(OrderInfo orderInfo) returns json|http:InternalServerError {
        string|error workflowId = workflow:run(orderWorkflow, orderInfo);
        if workflowId is error {
            return <http:InternalServerError>{body: {message: workflowId.message()}};
        }
        return {workflowId: workflowId};
    }

    resource function post [string orderId]/payment(PaymentNotification paymentNotification)
            returns json|http:InternalServerError {
        error? result = workflow:sendData(orderWorkflow, orderId, "paymentInfo",
                {status: paymentNotification.status});
        if result is error {
            return <http:InternalServerError>{body: {message: result.message()}};
        }
        return {status: "accepted"};
    }
}

service /claims on new http:Listener(8082) {

    resource function post .(ClaimInfo claimInfo) returns json|http:InternalServerError {
        string|error workflowId = workflow:run(insuranceClaimWorkflow, claimInfo);
        if workflowId is error {
            return <http:InternalServerError>{body: {message: workflowId.message()}};
        }
        return {workflowId: workflowId};
    }
}
