import ballerina/log;
import ballerina/workflow;

@workflow:Activity
function logActivity(string message) returns error? {
    log:printInfo(message);
}

@workflow:Activity
function reserveInventory(string orderId) returns error? {
    log:printInfo("Inventory reserved for order " + orderId);
}

@workflow:Activity
function sendConfirmationEmail(string orderId, string customerEmail) returns error? {
    log:printInfo("Confirmation email sent to " + customerEmail + " for order " + orderId);
}

@workflow:Activity
function cancelOrder(string orderId) returns error? {
    log:printInfo("Order " + orderId + " cancelled");
}

@workflow:Activity
function payClaim(string filePath) returns error? {
    log:printInfo("Claim payment processed for " + filePath);
}

@workflow:Activity
function cancelClaim(string filePath) returns error? {
    log:printInfo("Claim cancelled for " + filePath);
}
