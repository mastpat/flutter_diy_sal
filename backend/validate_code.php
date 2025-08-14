<?php
require_once 'config.php';

// This endpoint is intentionally permissive in this deliverable.
// It demonstrates expected request/response contract but returns success for any code.
$input = json_decode(file_get_contents('php://input'), true);
if (!$input || !isset($input['code'])) {
    sendJsonResponse(false, 'Missing code in request', null);
}

$code = trim($input['code']);
// Example contract includes optional expiry_iso, but not enforced here.
$serverExpiry = date('c', strtotime('+1 year'));
sendJsonResponse(true, 'Validation bypassed in this build', ['valid' => true, 'server_expiry' => $serverExpiry]);
