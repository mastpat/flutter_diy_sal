<?php
// Helper utilities for consistent responses.

function send_success($message, $data = null) {
    http_response_code(200);
    echo json_encode(['success' => true, 'message' => $message, 'data' => $data]);
    exit;
}

function send_error($message, $code = 400, $data = null) {
    http_response_code($code);
    echo json_encode(['success' => false, 'message' => $message, 'data' => $data]);
    exit;
}
