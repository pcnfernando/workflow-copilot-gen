import ballerina/workflow;

@workflow:Workflow
function orderWorkflow(workflow:Context ctx, OrderInfo input, OrderEvents events) returns OrderResult|error {
    () _ = check ctx->callActivity(logActivity, {message: "Starting order workflow for " + input.id});

    () _ = check ctx->callActivity(reserveInventory, {orderId: input.id});

    PaymentInfo paymentInfo = check wait events.paymentInfo;

    if paymentInfo.status == "SUCCESS" {
        () _ = check ctx->callActivity(sendConfirmationEmail, {orderId: input.id, customerEmail: input.customerEmail});
        return {orderId: input.id, status: "COMPLETED"};
    }

    () _ = check ctx->callActivity(cancelOrder, {orderId: input.id});
    return {orderId: input.id, status: "CANCELLED"};
}

@workflow:Workflow
function insuranceClaimWorkflow(workflow:Context ctx, ClaimInfo input) returns ClaimResult|error {
    () _ = check ctx->callActivity(logActivity, {message: "Starting insurance claim workflow for " + input.filePath});

    ClaimDecision|workflow:HumanTaskError decision = ctx->awaitHumanTask("Validate Documents",
            userRoles = "Finance", taskInput = {filePath: input.filePath}, title = "Validate Documents",
            description = "Review and validate the submitted claim documents");

    if decision is workflow:HumanTaskTimeoutError {
        () _ = check ctx->callActivity(cancelClaim, {filePath: input.filePath});
        return {status: "CANCELLED", reason: "Document validation timed out"};
    } else if decision is error {
        return decision;
    }

    if decision.status == "APPROVED" {
        () _ = check ctx->callActivity(payClaim, {filePath: input.filePath});
        return {status: "PAID"};
    }

    () _ = check ctx->callActivity(cancelClaim, {filePath: input.filePath});
    string? reason = decision.reason;
    return {status: "CANCELLED", reason};
}
