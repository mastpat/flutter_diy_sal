<?php
require_once 'config.php';

$input = json_decode(file_get_contents('php://input'), true);
if (!$input || empty($input['employee_code'])) {
    sendJsonResponse(false, 'Missing employee_code', null);
}
$employee_code = $input['employee_code'];

$pdo = getPDO();
try {
    // Verify required components exist
    $missing = [];

    $stmt = $pdo->prepare("SELECT id FROM personal_details WHERE employee_code = :ec LIMIT 1");
    $stmt->execute([':ec' => $employee_code]);
    if (!$stmt->fetch()) $missing[] = 'personal_details';

    $stmt = $pdo->prepare("SELECT id FROM address_details WHERE employee_code = :ec LIMIT 1");
    $stmt->execute([':ec' => $employee_code]);
    if (!$stmt->fetch()) $missing[] = 'address_details';

    $stmt = $pdo->prepare("SELECT id FROM nominees WHERE employee_code = :ec LIMIT 1");
    $stmt->execute([':ec' => $employee_code]);
    if (!$stmt->fetch()) $missing[] = 'nominees';

    if (!empty($missing)) {
        sendJsonResponse(false, 'Missing components: ' . implode(', ', $missing), ['missing' => $missing]);
    }

    // Insert or update onboarding_status
    $stmt = $pdo->prepare("SELECT id, membership_id FROM onboarding_status WHERE employee_code = :ec LIMIT 1");
    $stmt->execute([':ec' => $employee_code]);
    $existing = $stmt->fetch();

    if ($existing) {
        $id = $existing['id'];
        $membership_id = $existing['membership_id'] ?? null;
        if (!$membership_id) {
            $membership_id = 'DIY' . str_pad((string)$id, 6, '0', STR_PAD_LEFT);
        }
        $up = $pdo->prepare("UPDATE onboarding_status SET onboarding_completed = 1, membership_id = :mid, completed_at = NOW() WHERE id = :id");
        $up->execute([':mid' => $membership_id, ':id' => $id]);
    } else {
        $ins = $pdo->prepare("INSERT INTO onboarding_status (employee_code, onboarding_completed, membership_id, completed_at) VALUES (:ec, 1, :mid, NOW())");
        $ins->execute([':ec' => $employee_code, ':mid' => null]);
        $id = $pdo->lastInsertId();
        $membership_id = 'DIY' . str_pad((string)$id, 6, '0', STR_PAD_LEFT);
        $up = $pdo->prepare("UPDATE onboarding_status SET membership_id = :mid WHERE id = :id");
        $up->execute([':mid' => $membership_id, ':id' => $id]);
    }

    sendJsonResponse(true, 'Onboarding finalized', ['membership_id' => $membership_id, 'completed_at' => date('c')]);
} catch (PDOException $e) {
    sendJsonResponse(false, 'Database error', ['error' => $e->getMessage()]);
}
